enum 50400 TruckStatus
{
    Extensible = true;

    value(0; "IsHome")
    {
        Caption = 'IsHome';
    }
    value(1; GoingToHome)
    {
        Caption = 'GoingToHome';
    }

    value(2; "Unloading")
    {
        Caption = 'UnLoading';
    }

    value(3; GoingToDestination)
    {
        Caption = 'GoingToDestination';
    }

    value(4; IsAtDestination)
    {
        Caption = 'IsAtDestination';
    }
}
