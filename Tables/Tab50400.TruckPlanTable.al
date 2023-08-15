table 50400 TruckPlanTable
{
    Caption = 'TruckPlanTable';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Driver; Code[20])
        {
            Caption = 'Driver';
            TableRelation = Employee;

            trigger OnValidate()
            var
                EmployeeRecord: Record Employee;
            begin
                if rec.Driver <> '' then begin
                    EmployeeRecord.Get(rec.Driver);
                    rec.FullDriverName := EmployeeRecord.FullName;
                end;
            end;
        }

        field(6; FullDriverName; Text[256])
        {
            Caption = 'FullDriverName';

        }

        field(3; StartAddress; Code[20])
        {
            Caption = 'StartAddress';
            TableRelation = SimpleAddress;
        }


        field(4; EndAddress; Code[20])
        {
            Caption = 'EndAddress';
            TableRelation = SimpleAddress;
        }


        field(5; Status; Enum TruckStatus)
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNoSeriesCode: Code[20];
    begin
        if rec."No." = '' then
            // If it's empty, initialize a new series using the NoSeriesManagement codeunit
            NoSeriesMgt.InitSeries('TRUCKPLANNO', '', Today(), "No.", NewNoSeriesCode);
    end;

    trigger OnModify()
    begin
        OnTruckPlanUpdated(rec);
    end;

    [IntegrationEvent(false, false)]
    procedure OnTruckPlanUpdated(TruckPlanRecord: Record TruckPlanTable)
    begin
    end;
}
