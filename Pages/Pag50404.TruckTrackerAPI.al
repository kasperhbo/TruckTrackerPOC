page 50404 TruckTrackerAPI
{
    APIGroup = 'truckPlanningGroup';
    APIPublisher = 'kasperDeBruin';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'truckTrackerAPI';
    DelayedInsert = true;
    EntityName = 'truckPlan';
    EntitySetName = 'truckPlans';
    PageType = API;
    SourceTable = TruckPlanTableApi;
    ODataKeyFields = SystemId;

    // // SourceTableView = where("Driver" = const());

    layout
    {
        area(Content)
        {
            field(id; rec.SystemId)
            {
                ApplicationArea = All;
                Caption = 'SystemId', Locked = true;
                Editable = false;
            }

            field(planNo; rec.planNo)
            {
                ApplicationArea = All;
                Caption = 'planNo', Locked = true;
                Editable = false;
            }

            field(newStatus; rec.Status)
            {
                ApplicationArea = All;
                Caption = 'newStatus', Locked = true;
                Editable = false;
            }

            field(TestSetupField; Rec."Test Setup Field")
            {
                ApplicationArea = All;
                Caption = 'Test Setup Field', Locked = true;
            }
        }
    }

    [ServiceEnabled]
    procedure UpdateTruckPlan(var ActionContext: WebServiceActionContext; RecordNo: Code[20]; NewStatusId: Integer)
    var
        TruckPlanTable: Record TruckPlanTable;
        NewStatus: Enum TruckStatus;
    begin
        NewStatus := TruckStatus::IsHome;
        case NewStatusId of
            0:
                NewStatus := TruckStatus::IsHome;
            1:
                NewStatus := TruckStatus::GoingToHome;
            2:
                NewStatus := TruckStatus::Unloading;
            3:
                NewStatus := TruckStatus::GoingToDestination;
            4:
                NewStatus := TruckStatus::IsAtDestination;
        end;

        TruckPlanTable.Get(RecordNo);
        TruckPlanTable.Status := NewStatus;
        TruckPlanTable.Modify();

        OnTruckPlanUpdated(TruckPlanTable);

        CurrPage.Update();

        ActionContext.SetObjectType(ObjectType::Table);
        ActionContext.SetObjectId(Database::TruckPlanTable);

        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    [IntegrationEvent(false, false)]
    procedure OnTruckPlanUpdated(TruckPlanRecord: Record TruckPlanTable)
    begin
    end;

}

