var pictureUpload = function(cb) {
  $('#imageUpload').modal('show');

  var $input = $("#input-700")
  $input.fileinput({
    uploadUrl: window.baseUrl + "/upload", // server upload action
    uploadAsync: false,
    showUpload: false, // hide upload button
    showRemove: false, // hide remove button
    minFileCount: 1,
    maxFileCount: 1
  }).on("filebatchselected", function(event, files) {
    $input.fileinput("upload");
  }).on('filebatchuploadsuccess', function(event, data, previewId, index) {
    $('#imageUpload').modal('hide');
    cb(data.response.url);
  });
}

$(".bmarkdown").markdown({
  additionalButtons: [
    [{
      name: "groupCustomLink",
      data: [{
        name: "cmdCustomImage",
        toggle: true, // this param only take effect if you load bootstrap.js
        title: "Image",
        icon: "glyphicon glyphicon-picture",
        callback: function(e){
          var urlLink = pictureUpload(function (url) {
            var chunk = '![Insert a description here]('+url+')';
            e.replaceSelection(chunk);
            cursor = selected.start;
            e.setSelection(cursor,cursor+chunk.length);
          });
        }
      },
      {
        name: "cmdCustomLink",
        toggle: true, // this param only take effect if you load bootstrap.js
        title: "Link",
        icon: "glyphicon glyphicon-link",
        callback: function(e){


        }
      }]
    }]
  ],
  reorderButtonGroups: ['groupFont', 'groupCustomLink', 'groupMisc', 'groupUtil'],
  disabledButtons: ['cmdImage']

});
