codeunit 50400 BingMaps
{

}

controladdin Maps
{
    Scripts =
        'https://maps.googleapis.com/maps/api/js',
        'code/scripts.js';
    StartupScript = 'code/startup.js';

    RequestedHeight = 300;
    RequestedWidth = 300;
    MinimumHeight = 250;
    MinimumWidth = 250;
    MaximumHeight = 500;
    MaximumWidth = 500;
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;

    event ControlReady();

    procedure ShowAddress();


}
