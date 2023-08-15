codeunit 50400 BingMaps
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Page, Page::TruckTrackerAPI, OnTruckPlanUpdated, '', false, false)]
    local procedure RefreshTruckPlan(TruckPlanRecord: Record TruckPlanTable)
    begin
        // Your code to handle the update goes here
        // Message('update');
    end;

    [EventSubscriber(ObjectType::Table, Database::TruckPlanTable, OnAfterModifyEvent, '', false, false)]
    local procedure ModifyTP()
    begin
        // Your code to handle the insert goes here
        // Message('modify');
    end;
}

controladdin Maps
{
    Scripts =
        'https://maps.googleapis.com/maps/api/js?key=AIzaSyDJ6Rc5T6uNahos9sYW6lzZ7j6ub4EwH0w',
        'https://use.fontawesome.com/releases/v5.15.3/js/all.js',
        'code/scripts.js';
    StartupScript = 'code/startup.js';

    // vscode-file://vscode-app/c:/Users/k.debruin/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html    // RequestedHeight = 900;
    // RequestedWidth = 900;

    VerticalStretch = true;
    HorizontalStretch = true;

    MinimumHeight = 250;
    MinimumWidth = 250;

    VerticalShrink = true;
    HorizontalShrink = true;

    RequestedHeight = 780;
    RequestedWidth = 250;

    MaximumHeight = 1200;
    MaximumWidth = 1200;

    event ControlReady();

    procedure CodeAddress(Address: Text; InvokeEvent: Boolean);

    procedure MoveCenterToLocation(Lat: Text; Lon: Text);

    event SetRouteErrorCallback(ErrorCode: Text)
    procedure SetRoute(StartAddress: Text; EndAddress: Text; Driver: Text);

    procedure InitializeHtml();
    event InitializeHtmlCallback();

    procedure StartUpdateCars();

    procedure StartDriving(DriverID: Text);

    procedure GetMarkerByDriverName(driverName: Text);
    event GetMarkerByDriverNameCallback(Found: Boolean; Lat: Text; Lon: Text);

    event UpdateDriverLocationCallback(DriverName: Text; Lat: Text; Lon: Text);

    event DriverReachedDestinationCallback(DriverID: Text);
    event DriverStartsUnloading(DriverID: Text);
    event DriverFinishedUnloading(DriverID: Text);

    procedure RemoveDriver(DriverID: Text);

    event RefreshPageCallback();

}
