$(document).ready(function()
{
    $('#language').change(function()
    {
        var selectedLang = $('#language option:selected').val();

        if (selectedLang)
        {
            window.location.replace('/locale/' + selectedLang);
        }

        return false;
    });

    myNewGirl.misc.multiSelect();

    myNewGirl.admin.packagePrice();
    myNewGirl.admin.dataTablesInit();
    myNewGirl.admin.amendPackagePrices();
    myNewGirl.admin.deletePackagePrice();
    myNewGirl.admin.packagePriceCommission();
    myNewGirl.admin.amendPackagePriceCommissions();
    myNewGirl.admin.deletePackagePriceCommission();
});
