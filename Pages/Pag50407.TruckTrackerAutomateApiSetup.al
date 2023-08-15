page 50407 TruckTrackerAutomateApiSetup
{
    ApplicationArea = All;
    Caption = 'TruckTrackerAutomateApiSetup';
    UsageCategory = Administration;
    PageType = Card;
    SourceTable = TruckPlanTableApi;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Test Setup Field"; Rec."Test Setup Field")
                {
                    ApplicationArea = All;
                }

                field("No"; Rec.PlanNo)
                {
                    ApplicationArea = All;
                }

                field("Status"; rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
