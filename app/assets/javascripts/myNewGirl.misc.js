myNewGirl.misc =
{
    modal: function(target)
    {
        $(target).modal(
        {
            backdrop: 'static',
            keyboard: false
        });
    },

    multiSelect: function()
    {
        $('select.chosen').chosen();
    }
}