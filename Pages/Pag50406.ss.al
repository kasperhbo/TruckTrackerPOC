page 50406 "ZY Power Automate Setup Entity"
{
    Caption = 'powerAutomateSetup', Locked = true;
    DelayedInsert = true;
    EntityName = 'powerAutomateSetup';
    EntitySetName = 'powerAutomateSetups';
    ODataKeyFields = SystemId;
    APIPublisher = 'zy';
    APIGroup = 'zygroup';
    APIVersion = 'v2.0';
    PageType = API;
    SourceTable = "ZY Power Automate Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'Id', Locked = true;
                    Editable = false;
                }
                field(testSetupField; Rec."Test Setup Field")
                {
                    ApplicationArea = All;
                    Caption = 'TestSetupField', Locked = true;
                }
            }
        }
    }

    [ServiceEnabled]
    procedure ZYTestAction(var actionContext: WebServiceActionContext)
    var
        Item: Record Item;
    begin
        Item.Get('1896-S');
        Item.Description := Item.Description + 'ZY';
        Item.Modify();
        Message('Test Message');

        // Set the result code to inform the caller that an item was created.
        actionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;
}