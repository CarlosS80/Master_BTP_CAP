namespace com.logaligroup;

using {
        cuid,
        managed,
        sap.common.Currencies,
        sap.common.CodeList
} from '@sap/cds/common';
  
 using {API_BUSINESS_PARTNER as bp} from '../srv/external/API_BUSINESS_PARTNER';

entity Header : cuid, managed {
        SalesO        : String(10);
        EMAIL         : String(40);
        FIRSTNAME     : String(40);
        LASTNAME      : String(40);
        COUNTRY       : String(30);
        CREATEON      : String(10);
        DELIVERYDATE  : String(10);
        ORDERSTATUS   : Association to Status; //statu_code
        RATING        : Decimal(3, 2);
        IMAGEURL      : LargeBinary  @Core.MediaType: imageType  @UI.IsImage;
        imageType     : String       @Core.IsMediaType;   
      //supplier      : Association to Suppliers; //supplier_ID    
      rsupplier     : Association to bp.A_Supplier;           //rsupplier - rsupplier_Supplier
        toItem        : Composition of many Items
                               on toItem.SalesO = $self;
        toReviews     : Composition of many Reviews
                               on toReviews.SalesO = $self;    
        toInventories : Composition of many Inventories
                        on toInventories.SalesO = $self;
        toSales       : Composition of many Sales
                        on toSales.SalesO = $self;                                      

};

entity Items : cuid, managed {
        NAME             : String(40);
        DESCRIPTION      : String(40);
        RELEASEDATE      : String(10);
        DISCONTINUEDDATE : String(10);
        PRICE            : Decimal(12, 2);
        HEIGHT           : Decimal(15, 3);
        WIDTH            : Decimal(13, 3);
        DEPTH            : Decimal(12, 2);
        QUANTITY         : Decimal(16, 2);
        UNITOFMEASURE    : String default 'KG';
        CURRENCY         : Association to Currencies;
        SalesO           : Association to Header;     
};

entity Suppliers : cuid {
    supplier     : String(10);
    supplierName : String(40);
    webAddress   : String(250);
};

entity Status : CodeList {
    key code        : String enum {
            InStock = 'In Stock';
            OutOfStock = 'Out of Stock';
            LowAvailability = 'Low Availability';
        }
        criticality : Int16; // 1,2,3,5
};

entity Reviews : cuid {
    rating     : Decimal(3, 2);
    date       : Date;
    user       : String(20);
    reviewText : LargeString;
    SalesO     : Association to Header; //SalesO_ID
};

entity Inventories : cuid {
    stockNumber : String(12);
    min         : Integer;
    max         : Integer;
    target      : Integer;
    quantity    : Decimal(6, 3);
    baseUnit    : String default 'EA';
    SalesO      : Association to Header; // SalesO_ID
};

entity Sales : cuid {
    month         : String(20);
    monthCode     : String(2);
    year          : String(4);
    quantitySales : Integer;
    SalesO        : Association to Header;
};

entity Options : CodeList {
    key code : String(10) enum {
            A = 'Add';
            D = 'Discount'
        }
}