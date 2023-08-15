table 50401 SimpleAddress
{
    Caption = 'SimpleAddress';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "AddressNO."; Code[20])
        {
            Caption = 'AddressNO.';
        }
        field(2; Address; Text[30])
        {
            Caption = 'Address';
        }
        field(3; City; Text[30])
        {
            Caption = 'City';
        }
        field(4; Country; Text[30])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";
        }
        field(5; Province; Text[30])
        {
            Caption = 'Province';
        }
    }
    keys
    {
        key(PK; "AddressNO.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNoSeriesCode: Code[20];
    begin
        if rec."AddressNO." = '' then
            // If it's empty, initialize a new series using the NoSeriesManagement codeunit
            NoSeriesMgt.InitSeries('SIMPLE_ADDRESS_NO', '', Today(), "AddressNO.", NewNoSeriesCode);
    end;
}
