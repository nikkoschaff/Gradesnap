      $(function () {
          // Initialize the jQuery File Upload widget:
          $('#fileupload').fileupload();
          //
          // Load existing files:
          $.getJSON($('#fileupload').prop('action'), function (files) {
            var fu = $('#fileupload').data('fileupload'),
              template;
            fu._adjustMaxNumberOfFiles(-files.length);
            template = fu._renderDownload(files)
              .appendTo($('#fileupload .files'));
            // Force reflow:
            fu._reflow = fu._transition && template.length &&
              template[0].offsetWidth;
            template.addClass('in');
            $('#loading').remove();
          });

      });
