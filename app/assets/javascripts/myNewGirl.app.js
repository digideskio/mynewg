myNewGirl.app =
{
    jsonErrors: function(evt, xhr, status, form)
    {
        var content, value, _i, _len, _ref, $this;
        $this = form;
        content = $this.children('#errors');
        content.find('ul').empty();
        _ref = $.parseJSON(xhr.responseText).errors;
        // Append errors to list on page
        for (_i = 0, _len = _ref.length; _i < _len; _i++)
        {
            value = _ref[_i];
            content.show().find('ul').append('<li><i class="icon-cancel-circle"></i>' + value + '</li>');
        }
    },

    resizeCover: function()
    {
        if($('.cover')[0]) // if have cover image in the page
        {
            // console.log('run resize');
            var resize = function() {
                var frame = $('.cover');
                var cover = $('.cover img');
                var frameRatio = frame.width()/frame.height();
                var coverRatio = cover.width()/cover.height();
                if(frameRatio > coverRatio){
                    cover.height('auto');
                    cover.width('100%');
                }
                else {
                    cover.height('100%');
                    cover.width('auto');
                }
            };

            resize();
            $( window ).resize(resize);
        }
    },

    resizeGallery: function()
    {
        if($('.gallery-photo')[0]) // if have cover image in the page
        {
            var resize = function () {
                $('.gallery-photo').each(function() {
                    $(this).height($(this).width());
                    var width = $(this).children().width();
                    var height = $(this).children().height();

                    if(width < height) {
                        $(this).children().width('100%')
                        $(this).children().height('auto')
                    }
                    else if(height < width) {
                        $(this).children().width('auto')
                        $(this).children().height('100%')
                    }
                });
            };

            resize();
            $( window ).resize(resize);
        }
    },

    validateReferral: function()
    {
        $('body').on('submit', '#validate-referral', function()
        {
            var $this = $(this);
                
            $.ajax(
            {
                url: '/referral/validate',
                type: 'POST',
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    window.location.href = data.url;
                },
                error: function(xhr, evt, status)
                {

                    myNewGirl.app.jsonErrors(evt, xhr, status, $this);
                }
            });
            return false;
        });
    },

    validateDiscountCode: function()
    {
        $('body').on('submit', '#validate-discount-code', function()
        {
            var $this = $(this),
                url = $this.attr('action');
                
            $.ajax(
            {
                url: url,
                type: 'POST',
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $this.find('p').html(data.message)
                    $('input#discount_code').val(data.code);
                    $('p#' + data.price_type + ' span').html(data.price);
                },
                error: function(xhr, evt, status)
                {
                    $this.find('p').html(xhr.responseJSON.error)
                }
            });
            return false;
        });
    },

    uploadImage: function()
    {
        $('.update-user-photo input').change(function(){
            $(this).parent().ajaxSubmit(
            {
                beforeSubmit: function(a,f,o) 
                {
                    o.dataType = 'json';
                },
                complete: function(XMLHttpRequest, textStatus) 
                {
                    var json = $.parseJSON(XMLHttpRequest.responseText)
                    $('.cover .cover-inner img').attr('src', json.cover_photo);
                    $('.profile-image .profile-image-inner img').attr('src', json.profile_photo)
                    $('.navbar-picture img').attr('src', json.profile_photo)
                    console.log(XMLHttpRequest.responseText);
                },
            });
        });
    },

    uploadImages: function()
    {
        $('.create-user-photos input').change(function(){
            $(this).parent().ajaxSubmit(
            {
                beforeSubmit: function(a,f,o) 
                {
                    o.dataType = 'json';
                },
                complete: function(XMLHttpRequest, textStatus) 
                {
                    var json = $.parseJSON(XMLHttpRequest.responseText);
                    $('.gallery-photos .add-image').before(json.gallery_photo);
                },
            });
        });
    },

    uploadImageTriggers: function()
    {   
        $('.profile-image .profile-image-inner div').click(function()
        {
            $('.profile-image .profile-image-inner form input').click();
            return false;
        });
        $('.cover .cover-inner div').click(function()
        {
            $('.cover .cover-inner form input').click();
            return false;
        });
        $('.upload-photos').click(function()
        {
            $('.create-user-photos input').click();
            return false;
        });
    },

    deleteImage: function()
    {
        $('body').on('click', '.delete-gallery-photo', function()
        {
            var attachmentId = $(this).attr('data-attachment-id'),
                username = $('.user-profile').attr('data-username');
            $.ajax(
            {
                url: '/' + username + '/images/' + attachmentId,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    $('#attachment-preview').modal('hide');
                    $('[data-attachment-id="' + attachmentId + '"]').remove();
                }
            });
            return false;
        });
    },

    createCard: function()
    {
        $('body').on('submit', '#create-omise-card', function()
        {
            var $this = $(this),
                username = $(this).attr('data-username');
                
            $.ajax(
            {
                url: '/' + username + '/create_card',
                type: 'POST',
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    if (data.first)
                    {
                        $('#cards').html(data.card);
                    }
                    else
                    {
                        $('#cards').append(data.card);
                    }
                    $this[0].reset();
                },
                error: function(xhr, evt, status)
                {

                    myNewGirl.app.jsonErrors(evt, xhr, status, $this);
                }
            });
            return false;
        });
    },

    deleteCard: function()
    {
        $('body').on('click', '.delete-card', function()
        {
            var cardId = $(this).attr('data-card-id'),
                username = $(this).attr('data-username');
            $.ajax(
            {
                url: '/' + username + '/delete_card',
                type: "DELETE",
                data: { 'card_token': cardId },
                dataType: "json",
                success: function(data)
                {
                    if(data.last)
                    {
                        $('#cards').html('<p>You currently do not have any cards associated with your account.</p>');
                    }
                    else
                    {
                        $('[data-card-id-wrapper="' + cardId + '"]').remove();
                    }
                }
            });
            return false;
        });
    },

    previewImage: function()
    {
        $('body').on('click', '.gallery-photo', function()
        {
            var attachmentId = $(this).attr('data-attachment-id'),
                username = $('.user-profile').attr('data-username');

            $.ajax(
            {
                url: '/' + username + '/images/' + attachmentId,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('#attachment-modal').html(data.modal);
                    $('#attachment-preview').modal(
                    {
                        backdrop: 'static',
                        keyboard: false
                    });
                }
            });
            return false;
        });
    },

    deleteFavourite: function()
    {
        $('body').on('click', '.delete-favourite', function()
        {
            var favouriteId = $(this).attr('data-favourite-id');
            $.ajax(
            {
                url: '/favourites/' + favouriteId,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    $('.user-profile #favourite').html(data.form);
                }
            });
            return false;
        });
    },

    createFavourite: function()
    {
        $('body').on('submit', '.create-favourite', function()
        {
            $this = $(this);

            $.ajax(
            {
                url: '/favourites',
                type: "POST",
                data: $this.serialize(),
                dataType: "json",
                success: function(data)
                {
                    $('.user-profile #favourite').html(data.form);
                }
            });
            return false;
        });
    }
}