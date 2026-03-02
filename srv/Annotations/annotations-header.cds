using {Sales_order as service} from '../service'; 

using from './annotations-items';
using from './annotations-reviews';
using from './annotations-Inventories';
using from './annotations-sales';

annotate service.Header with @odata.draft.enabled;

// Titulos
annotate service.Header with {
    SalesO      @title : 'Sales Order';
    FIRSTNAME   @title : 'First Name';
    LASTNAME    @title : 'Last Name';
    EMAIL       @title : 'Email';
    COUNTRY     @title : 'Country';    
    ORDERSTATUS @title : 'Order Status';
    RATING      @title: 'Rating';
    IMAGEURL    @title: 'Image';
    rsupplier   @title: 'Supplier (Remote)';
}

annotate service.Header with {
        rsupplier @Common: {
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Supplier',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : rsupplier_Supplier,
                    ValueListProperty : 'Supplier'
                }
            ]
        }
    }
} 



annotate service.Header with @(

// Header Info
 UI.HeaderInfo                     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Sales Order',
        TypeNamePlural: 'Sales Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: FIRSTNAME
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: SalesO
        }
    },
//-------------------------------------
// Filtros - Selection Fields
    UI.SelectionFields                : [
        SalesO,
        CREATEON,
        ORDERSTATUS_code         
    ],
//------------------------------------ 
// Line ITEM
 UI.LineItem : [
    {
        $Type : 'UI.DataField',
            Value : IMAGEURL
    },    
    {
        $Type : 'UI.DataField', 
        Value : SalesO
    },        
    {
        $Type : 'UI.DataField',
        Value : FIRSTNAME,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }             
    },    
    {
        $Type : 'UI.DataField',
        Value : LASTNAME,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }             
    },           
    {
        $Type : 'UI.DataField',
        Value : EMAIL,        
    },    
    {
        $Type : 'UI.DataField',
        Value : COUNTRY,
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }             
    },       
       {
        $Type       : 'UI.DataField',
        Value       : ORDERSTATUS.name,
        Label       : 'Status',
        Criticality : ORDERSTATUS.criticality
    }, 
    {
        $Type  : 'UI.DataFieldForAnnotation',
        Target : @UI.DataPoint,
        Label  : 'Average Rating',
            @HTML5.CssDefaults: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }             
    },             
        {
        $Type : 'UI.DataField',
        Value : rsupplier,        
    },              
 ],
//------------------------------------------
    UI.DataPoint                      : {
        $Type        : 'UI.DataPointType',
        Value        : RATING,
        Visualization: #Rating,
        Title        : 'Star Ratings'
    },
//------------------------------------------    
//    FieldGroup
//*************************************
    UI.FieldGroup #LASTNAME: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : LASTNAME,
                 Label: ''
             },   
                 
         ],
     }, 
//*************************************
    UI.FieldGroup #EMAIL: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : EMAIL,
                 Label: ''
             },   
                 
         ],
     },      
//*************************************
    UI.FieldGroup #COUNTRY: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : COUNTRY,
                 Label: ''
             },   
                 
         ],
     },           
 //*************************************
    UI.FieldGroup #ORDERSTATUS: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : ORDERSTATUS,
                 Label: ''
             },   
                 
         ],
     },                    
//*************************************
     UI.FieldGroup #Image: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : IMAGEURL,
                 Label: ''
             },   
         ],
     },
//*************************************     
    UI.FieldGroup #Availability       : {
        $Type: 'UI.FieldGroupType',
        Data : [{
            $Type      : 'UI.DataField',
            Value      : ORDERSTATUS,
            Criticality: ORDERSTATUS.criticality,
            Label      : '',
            @Common.FieldControl : {
                $edmJson: {
                    $If: [
                        {
                            $Eq: [
                                {
                                    $Path: 'IsActiveEntity'
                                },
                                false
                            ]
                        },
                        1,
                        3
                    ]
                }
            }
        }]
    },     
//*************************************
     UI.FieldGroup #Delivery: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : DELIVERYDATE,
                 Label: ''
             },   
         ],
     },
//*************************************
     UI.FieldGroup #Status: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : ORDERSTATUS_code,
                 Criticality: ORDERSTATUS.criticality ,
                 Label      : 'Status',   

             },                
         ],
     },     
//*************************************      
   UI.FieldGroup #RSupplier: {
         $Type : 'UI.FieldGroupType',
         Data : [
             {
                 $Type : 'UI.DataField',
                 Value : rsupplier_Supplier,
                 Label: ''
             },   
                 
         ],
     },
    
//----------------------------------------------
//    HeaderFacets
    UI.HeaderFacets                   : [
    /*    {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#Data', 
             Label : ''
         },     */        
//*************************************        
        {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#Image',
             Label : 'Image'
         },
//*************************************
        {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#LASTNAME',
             Label : 'Last Name'
         },
//*************************************   
        {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#EMAIL',
             Label : 'Email'
         },
//*************************************      
        {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#COUNTRY',
             Label : 'Country'
         },
//*************************************      
       /* {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#ORDERSTATUS',
             Label : 'Order Status'
         },   */
//************************************* 
        {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#Delivery',
             Label : 'Delivery Date'
         },
//*************************************
        {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#Availability', 
             Label : 'Availability'
         },         
//*************************************
       {
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#RSupplier', 
             Label : 'Supplier'
         },         
//*************************************
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint'
        },
//*************************************

    ],

//--------------------------------------------------
//    Facets
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            //Target : 'toItem/@UI.FieldGroup#TechnicalData',
            Target : 'toItem/@UI.LineItem',
            Label : 'Technical Data'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toReviews/@UI.LineItem',
            Label : 'Reviews',
            ID : 'toReviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'toInventories/@UI.LineItem',
            Label : 'Inventory Information',
            ID : 'toInventories'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toSales/@UI.Chart',
            Label : 'Sales',
            ID : 'toSales'
        }        
    ]


) ;