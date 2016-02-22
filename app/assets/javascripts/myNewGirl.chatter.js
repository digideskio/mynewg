myNewGirl.chatter =
{
    createMessage: function()
    {
        $('body').on('submit', '#send-message', function()
        {
            var $this = $(this);
            $.ajax(
            {
                url: '/messages',
                type: 'POST',
                data: $(this).serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $this[0].reset();
                    $('ul#message-history').append(data.message);
                }
            });
            return false;
        });
    }
}