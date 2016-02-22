myNewGirl.admin =
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
        // Scroll to error list
        if (!$this.parent().hasClass('modal-content'))
        {
            $('body').scrollTo('.page-header', 800);
        }
        // Fade out loading animation
        $('.loading-overlay').css('height', '0').removeClass('active');
        $('.loading5').removeClass('active');
    },

    packagePrice: function()
    {
        $('body').on('click', '.package-price-button', function ()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#package-price-modal').html(data.modal);
                    myNewGirl.misc.modal('#package-price-form');
                }
            });
            return false;
        });
    },

    question: function()
    {
        $('body').on('click', '.question-button', function ()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#question-modal').html(data.modal);
                    myNewGirl.misc.modal('#question-form');
                }
            });
            return false;
        });
    },

    packagePriceCommission: function()
    {
        $('body').on('click', '.package-price-commission-button', function ()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#package-price-commission-modal').html(data.modal);
                    myNewGirl.misc.modal('#package-price-commission-form');
                }
            });
            return false;
        });
    },

    amendPackagePrices: function()
    {
        $('body').on('submit', '#amend_package_price', function()
        {
            var $this = $(this);
                url = $this.attr('action');
                method = $this.attr('data-method');

            $.ajax(
            {
                url: url,
                type: method,
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#package-price-form').modal('hide');
                    if (data.first_record)
                    {
                        $('#package-price-table').html(data.table);
                    }
                    else
                    {
                        if (method === 'POST')
                        {
                            $('#package-price-fields').append("<tr id=\'price_" + data.price_id + "\'>" + data.row +"</tr>");
                        }
                        else
                        {
                            $('tr#price_' + data.price_id).html(data.row);
                        }
                    }
                },
                error: function(xhr, evt, status)
                {
                    myNewGirl.admin.jsonErrors(evt, xhr, status, $this);
                }
            });
            return false;
        });
    },

    amendQuestions: function()
    {
        $('body').on('submit', '#amend_question', function()
        {
            var $this = $(this);
                url = $this.attr('action');
                method = $this.attr('data-method');

            $.ajax(
            {
                url: url,
                type: method,
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#question-form').modal('hide');
                    if (data.first_record)
                    {
                        $('#question-table').html(data.table);
                    }
                    else
                    {
                        if (method === 'POST')
                        {
                            $('#question-fields').append("<tr id=\'question_" + data.question_id + "\'>" + data.row +"</tr>");
                        }
                        else
                        {
                            $('tr#question_' + data.question_id).html(data.row);
                        }
                    }
                    soca.animation.alert(
                        '.widget-header',
                        'success',
                        'amend-question-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully ' + message + ' a question.',
                        5000
                    )
                },
                error: function(xhr, evt, status)
                {

                    myNewGirl.admin.jsonErrors(evt, xhr, status, $this);
                }
            });
            return false;
        });
    },

    amendPackagePriceCommissions: function()
    {
        $('body').on('submit', '#amend_package_price_commission', function()
        {
            var $this = $(this);
                url = $this.attr('action');
                method = $this.attr('data-method');

            $.ajax(
            {
                url: url,
                type: method,
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#package-price-commission-form').modal('hide');
                    if (data.first_record)
                    {
                        $('#package-price-commission-table').html(data.table);
                    }
                    else
                    {
                        if (method === 'POST')
                        {
                            $('#package-price-commission-fields').append("<tr id=\'commission_" + data.commission_id + "\'>" + data.row +"</tr>");
                        }
                        else
                        {
                            $('tr#commission_' + data.commission_id).html(data.row);
                        }
                    }
                },
                error: function(xhr, evt, status)
                {

                    myNewGirl.admin.jsonErrors(evt, xhr, status, $this);
                }
            });
            return false;
        });
    },

    deletePackagePrice: function()
    {
        $('body').on('click', '.package-price-delete', function()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    if (data.last_record)
                    {
                        $('#package-price-table').html(data.html)
                    }
                    else
                    {
                        $("tr#price_" + data.price_id).remove();
                    }
                    $('tr.price_' + data.price_id).remove();
                }
            });
            return false;
        });
    },

    deleteQuestion: function()
    {
        $('body').on('click', '.question-delete', function()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    if (data.last_record)
                    {
                        $('#question-table').html(data.html)
                    }
                    else
                    {
                        $("tr#question_" + data.question_id).remove();
                    }
                }
            });
            return false;
        });
    },

    deletePackagePriceCommission: function()
    {
        $('body').on('click', '.package-price-commission-delete', function()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    if (data.last_record)
                    {
                        $('#package-price-commission-table').html(data.html)
                    }
                    else
                    {
                        $("tr#commission_" + data.commission_id).remove();
                    }
                }
            });
            return false;
        });
    },

    checkInUser: function()
    {
        $('body').on('click', '.check-in-user', function()
        {
            var $this = $(this),
                eventId = $('.page-header').attr('data-event-id'),
                userId = $this.attr('data-user-id');

            $.ajax(
            {
                url: '/admin_old/events/' + eventId + '/check_in/' + userId,
                type: 'PATCH',
                dataType: 'json',
                success: function (data)
                {
                    $('tr#user_' + userId).replaceWith(data.row);
                }
            });
            return false;
        });
    },

    dataTablesInit: function()
    {
        var fromDateElement = $('#datatables-from-date');
        var toDateElement = $('#datatables-to-date');
        var table = $('#datatable').DataTable();
        var setDatePickerFilter = function(element)
        {
            element.datepicker(
            {
                autoclose: true,
                format: 'MM dd yyyy'
            }).on('changeDate', function(ev)
            {
                table.draw();
            });
        }

        if (!(fromDateElement && toDateElement)) return;

        $.fn.dataTable.ext.search.push(
            function(settings, data, dataIndex)
            {
                var fromDate = new Date(fromDateElement.val());
                var toDate = new Date(toDateElement.val());
                var date = new Date(data[1].split(' - ')[0]);

                var fromDatePresent = fromDate instanceof Date && !isNaN(fromDate.valueOf());
                var toDatePresent = toDate instanceof Date && !isNaN(toDate.valueOf());

                if (fromDatePresent && toDatePresent)  return fromDate <= date && toDate >= date;
                if (fromDatePresent && !toDatePresent) return fromDate <= date;
                if (!fromDatePresent && toDatePresent) return toDate >= date;

                return true;
            }
        );

        setDatePickerFilter(fromDateElement);
        setDatePickerFilter(toDateElement);
    }
}
