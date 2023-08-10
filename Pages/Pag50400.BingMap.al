page 50400 BingMap
{
    ApplicationArea = All;
    Caption = 'BingMap';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
            }

            usercontrol(Maps; Maps)
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage.Maps.ShowAddress();
                end;
            }
        }
    }
}
