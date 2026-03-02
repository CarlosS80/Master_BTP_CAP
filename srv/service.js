 const cds = require('@sap/cds');

module.exports = class Sales_order extends cds.ApplicationService {

   async init () { //async 

        const {Header, Inventories, VH_Supplier} = this.entities; //, VH_Supplier
        const bp = await cds.connect.to("API_BUSINESS_PARTNER");

        //CREATE  --> NEW
        //UPDATE
        //DELETE
        //READ

        //before,on,after

        
      this.on('READ', VH_Supplier, async (req) => {
            return await bp.tx(req).send({
                query: req.query,
                headers: {
                    apikey: process.env.APIKEY
                }
            });
        });
        
        this.before('NEW', Header.drafts, async (req) => {
            req.data.detail??= {
                UNITOFMEASURE: 'EA',
                WIDTH: null,
                DEPTH: null,
                HEIGHT: null,   
            }
        });

        this.before('NEW', Inventories.drafts, async (req) => {
            let dbp = await SELECT.one.from(Inventories).columns('max(stockNumber)');
            let dbd = await SELECT.one.from(Inventories.drafts).columns('max(stockNumber)');
            
            let max = parseInt(dbp.max);
            let max2 = parseInt(dbd.max);
            let newMax = 0;

            if (isNaN(max2)) {
                newMax = max + 1; //10000000360 --> 10000000361
            } else if (max < max2) {
                newMax = max2 + 1; //10000000361 --> 10000000362
            } else {
                newMax = max + 1;
            }

            req.data.stockNumber = newMax.toString();
        });

        this.on('setStock', async (req) => {
            const SalesOId = req.params[0].ID;
            const inventoryId = req.params[1].ID;

            const {quantity} = await SELECT.one.from(Inventories).columns('quantity').where({ID: inventoryId});
            let newAmount = 0;

            if (req.data.option === 'A') {
                newAmount = req.data.amount + quantity;

                if (newAmount > 300) {
                    await UPDATE(Header).set({ORDERSTATUS_code: 'InStock'}).where({ID: SalesOId});
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});
                return req.info(200,`The amount ${req.data.amount} has benn added to the inventory`);
            } else if (req.data.amount > quantity) {
                return req.error(400,`There is no availability for the requested quantiy`);
            } else {
                newAmount = quantity - req.data.amount;
                if (newAmount > 0 && newAmount <= 300) {
                    await UPDATE(SalesOId).set({ORDERSTATUS_code: 'LowAvailability'}).where({ID: SalesOId});
                } else if (newAmount === 0) {
                    await UPDATE(SalesOId).set({ORDERSTATUS_code: 'OutOfStock'}).where({ID: SalesOId});
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});
                return req.info(200,`The amount ${req.data.amount} has been removed from the inventory`)
            }
            
        });

        return super.init();
    }
}
    