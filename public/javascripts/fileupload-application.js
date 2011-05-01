$(function(){
  $("#upload-images").fileUploadUI({
    buildDownloadRow: function (file, handler) {
      if (typeof(file.name)!="undefined") {
        // \u3053\u3053\u306B\u753B\u50CF\u306E\u8AAC\u660E\u3092\u8FFD\u52A0 は「ここに画像の説明を追加」をエスケープしたもの
        $("#uploaded-images ul").append("<li>#ref(" + file.url + ",\u3053\u3053\u306B\u753B\u50CF\u306E\u8AAC\u660E\u3092\u8FFD\u52A0)</li>");
        $("#uploaded-images p, #uploaded-images ul").show();
      }
    }
  });

  $("#insert-images").click(function() {
    $("#uploaded-images").toggle();
  });
});
