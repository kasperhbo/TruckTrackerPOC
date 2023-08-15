page 50402 TruckPlans
{
    ApplicationArea = All;
    Caption = 'TruckPlans';
    PageType = List;
    SourceTable = TruckPlanTable;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Driver; Rec.Driver)
                {
                    ToolTip = 'Specifies the value of the Driver field.';
                }
                field(EndAddress; Rec.EndAddress)
                {
                    ToolTip = 'Specifies the value of the EndAddress field.';
                }
                field(StartAddress; Rec.StartAddress)
                {
                    ToolTip = 'Specifies the value of the StartAddress field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}

page 50403 TruckPlansListPart
{
    ApplicationArea = All;
    Caption = 'TruckPlansLP';
    PageType = ListPart;
    SourceTable = TruckPlanTable;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                group(Left)
                {
                    repeater(TRUCKLISTREP)
                    {
                        field(Driver; Rec.Driver)
                        {
                            ToolTip = 'Specifies the value of the Driver field.';
                        }

                        field(Status; Rec.Status)
                        {
                            ToolTip = 'Specifies the value of the Status field.';
                        }
                    }
                    field(TrackingDriver; TrackingDriver)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the TrackingDriver field.';
                    }

                    field(TrackingDriverNo; TrackingDriverNo)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the TrackingDriverNo field.';
                    }

                    group(Start)
                    {
                        field(TrackingDriverAddressStart; TrackingDriverStart.Address)
                        {
                            ApplicationArea = All;
                            Caption = 'Driver Start Address';
                            Editable = false;
                            ToolTip = 'Specifies the value of the TrackingDriverStart field.';
                        }

                        field(TrackingDriverCityStart; TrackingDriverStart.City)
                        {
                            ApplicationArea = All;
                            Caption = 'Driver Start City';
                            Editable = false;
                            ToolTip = 'Specifies the value of the TrackingDriverStart field.';
                        }

                        field(TrackingDriverCountryStart; TrackingDriverStart.Country)
                        {
                            ApplicationArea = All;
                            Caption = 'Driver Start Country';
                            Editable = false;
                            ToolTip = 'Specifies the value of the TrackingDriverStart field.';
                        }
                        group(Destination)
                        {
                            field(TrackingDriverAdressDestination; TrackingDriverDestination.Address)
                            {
                                ApplicationArea = All;
                                Caption = 'Driver End Address';
                                Editable = false;
                                ToolTip = 'Specifies the value of the TrackingDriverDestination field.';
                            }

                            field(TrackingDriverCityDestination; TrackingDriverDestination.City)
                            {
                                ApplicationArea = All;
                                Caption = 'Driver End City';
                                Editable = false;
                                ToolTip = 'Specifies the value of the TrackingDriverDestination field.';
                            }

                            field(TrackingDriverCountryDestination; TrackingDriverDestination.Country)
                            {
                                ApplicationArea = All;
                                Caption = 'Driver End Country';
                                Editable = false;
                                ToolTip = 'Specifies the value of the TrackingDriverDestination field.';
                            }
                        }
                    }
                }

                usercontrol(Maps; Maps)
                {
                    ApplicationArea = All;

                    trigger ControlReady();
                    begin
                        CurrPage.Maps.InitializeHtml();
                    end;

                    trigger InitializeHtmlCallback()
                    begin
                        SetRoutes();
                    end;


                    // trigger GetMarkerByDriverNameCallback(Found: Boolean; Lat: Text; Lon: Text)
                    // begin
                    //     if (Found) then begin
                    //         CurrPage.Maps.MoveCenterToLocation(Lat, Lon);
                    //     end;
                    // end;

                    // //TODO: Optimize this
                    trigger DriverReachedDestinationCallback(DriverID: Text)
                    var
                        DriverRec: Record Employee;
                        TruckPlanRec: Record TruckPlanTable;
                        Found: Boolean;
                    begin
                        if Rec.FindSet() then begin
                            repeat
                                if Rec.Driver = DriverID then begin
                                    Found := true;
                                    Rec.Status := Rec.Status::IsAtDestination;
                                    Rec.Modify();
                                    break;
                                end;
                            until Rec.Next() = 0;
                        end;
                    end;

                    trigger RefreshPageCallback()
                    begin
                        Message('refresh page');
                        CurrPage.Update();
                    end;
                }
            }
        }
    }


    var
        TrackingDriver: Text;
        TrackingDriverNo: Code[20];
        TrackingDriverStart: Record SimpleAddress;
        TrackingDriverDestination: Record SimpleAddress;
        BingMapsCodeUnit: Codeunit BingMaps;

    trigger OnAfterGetCurrRecord()
    var
        StartAddRec: Record SimpleAddress;
        EndAddRec: Record SimpleAddress;

        EmployeeRec: Record Employee;
        Address: Text;
    begin
        //get the driver
        if EmployeeRec.Get(rec.Driver) then begin
            CurrPage.Maps.GetMarkerByDriverName(EmployeeRec."No.");
            TrackingDriver := EmployeeRec.FullName();
            TrackingDriverNo := EmployeeRec."No.";

            //get the start address
            if TrackingDriverStart.Get(rec.StartAddress) then begin
                StartAddRec := TrackingDriverStart;
            end;

            //get the end address
            if TrackingDriverDestination.Get(rec.EndAddress) then begin
                EndAddRec := TrackingDriverDestination;
            end;
        end;

    end;

    trigger OnOpenPage()
    begin
        // CurrPage.Maps.InitializeHtml();
    end;

    procedure SetRouteForRec(TruckPlan: Record TruckPlanTable);
    var
        StartAddressRec: Record SimpleAddress;
        StartAdress: Text;
        EndAdressRec: Record SimpleAddress;
        EndStartAdress: Text;
        EmployeeRec: Record Employee;
    begin
        if StartAddressRec.Get(TruckPlan.StartAddress) then begin
            if (StartAddressRec.Address <> '') then begin
                StartAdress := StartAddressRec.Address;
            end;
            if (StartAddressRec.City <> '') then begin
                StartAdress := StartAdress + ', ' + StartAddressRec.City;
            end;
            if (StartAddressRec.Country <> '') then begin
                StartAdress := StartAdress + ', ' + StartAddressRec.Country;
            end;
        end;

        EndStartAdress := '';

        if EndAdressRec.Get(TruckPlan.EndAddress) then begin
            if (EndAdressRec.Address <> '') then begin
                EndStartAdress := EndAdressRec.Address;
            end;
            if (EndAdressRec.City <> '') then begin
                EndStartAdress := EndStartAdress + ', ' + EndAdressRec.City;
            end;
            if (EndAdressRec.Country <> '') then begin
                EndStartAdress := EndStartAdress + ', ' + EndAdressRec.Country;
            end;
        end;

        if EmployeeRec.Get(TruckPlan.Driver) then begin
            CurrPage.Maps.SetRoute(StartAdress, EndStartAdress, EmployeeRec."No.");
            // Message('Set route for %1', EmployeeRec."No.");
        end;
    end;

    procedure SetRoutes();
    begin
        // Message('Set routes');
        if Rec.FindSet() then begin
            repeat
                // Rec.EndAddress := Rec.StartAddress;
                Rec.Status := Rec.Status::IsHome;
                Rec.Modify();
                SetRouteForRec(Rec);
            until Rec.Next() = 0;
            CurrPage.Maps.StartUpdateCars();
        end;
    end;

    procedure StartTruck();
    begin
        CurrPage.Maps.StartDriving(Rec.Driver);
        Rec.Status := Rec.Status::GoingToDestination;
        Rec.Modify();
    end;

}