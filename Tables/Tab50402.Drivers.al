table 50402 Drivers
{
    Caption = 'Drivers';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "DriverNO."; Code[20])
        {
            Caption = 'DriverNO.';
        }
        field(2; DriverName; Text[256])
        {
            Caption = 'DriverName';
        }
    }
    keys
    {
        key(PK; "DriverNO.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNoSeriesCode: Code[20];
    begin
        if rec."DriverNO." = '' then
            // If it's empty, initialize a new series using the NoSeriesManagement codeunit
            NoSeriesMgt.InitSeries('DRIVER_NO', '', Today(), "DriverNO.", NewNoSeriesCode);
    end;
}
