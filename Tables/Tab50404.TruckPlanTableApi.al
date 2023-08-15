table 50404 TruckPlanTableApi
{
    Caption = 'TruckPlanTableApi';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Test Setup Field"; Boolean)
        {
            Caption = 'Test Setup Field';
            DataClassification = CustomerContent;
        }

        field(3; PlanNo; Boolean)
        {
            Caption = 'TPlanNo Field';
            DataClassification = CustomerContent;
        }

        field(4; Status; Enum TruckStatus)
        {
            Caption = 'TPlanNo Field';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        OnTruckPlanTableApiUpdated();
    end;


    [IntegrationEvent(false, false)]
    procedure OnTruckPlanTableApiUpdated()
    begin
    end;
}
