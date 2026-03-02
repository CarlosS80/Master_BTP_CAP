using {Sales_order as service} from '../service';

annotate service.VH_Supplier with {
    Supplier @title : 'Supplier';
};

annotate service.VH_Supplier with @(
    UI.SelectionFields  : [
        Supplier
    ]
);