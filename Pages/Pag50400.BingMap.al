page 50400 BingMap
{
    Caption = 'BingMap';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            part(TruckPlansListPart; TruckPlansListPart)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StartTracking)
            {
                ApplicationArea = All;
                Caption = 'Start Driving Current Selected Driver';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    CurrPage.TruckPlansListPart.Page.StartTruck();
                end;
            }
        }
    }

}
