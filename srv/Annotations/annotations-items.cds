using {Header as service} from '../service';

// 1. Definición de títulos y etiquetas de unidades
annotate service.Items with {
    NAME          @title: 'Product Name';
    DESCRIPTION   @title: 'Description';
    PRICE         @title: 'Price'   @Measures.ISOCurrency: CURRENCY_code;
    DEPTH         @title: 'Depth'   @Measures.Unit: UNITOFMEASURE;
    HEIGHT        @title: 'Height'  @Measures.Unit: UNITOFMEASURE;
    WIDTH         @title: 'Width'   @Measures.Unit: UNITOFMEASURE;
    UNITOFMEASURE @Common.IsUnit    @Common.FieldControl : #ReadOnly; 
};

annotate service.Items with @(
    // 2. Esta es la parte CRUCIAL: La tabla que se verá dentro del Header
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value : PRICE,
        },
        {
            $Type : 'UI.DataField',
            Value : DEPTH,
        },
        {
            $Type : 'UI.DataField',
            Value : HEIGHT,
        },
        {
            $Type : 'UI.DataField',
            Value : WIDTH,
        },
    ],

    // 3. Definición del grupo de campos (para el detalle del ítem)
    UI.FieldGroup #TechnicalData : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : DEPTH },
            { $Type : 'UI.DataField', Value : HEIGHT },
            { $Type : 'UI.DataField', Value : WIDTH },
            { $Type : 'UI.DataField', Value : PRICE },
            { $Type : 'UI.DataField', Value : NAME },
            { $Type : 'UI.DataField', Value : DESCRIPTION },
        ]
    },

    // 4. Facetas propias del Item (cuando haces clic en una fila de la tabla)
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#TechnicalData',
            Label : 'Technical Specifications'
        }
    ]
);