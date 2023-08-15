page 50401 SimpleAddress
{
    ApplicationArea = All;
    Caption = 'SimpleAddress';
    PageType = List;
    SourceTable = SimpleAddress;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("AddressNO."; Rec."AddressNO.")
                {
                    ToolTip = 'Specifies the value of the AddressNO. field.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                }
            }
        }
    }
}
