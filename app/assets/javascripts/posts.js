// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $("#upload-images").fileUploadUI({buildDownloadRow:function(a){
    typeof a.name!="undefined"&&($("#uploaded-images ul").append("<li>#ref("+a.url+",\u3053\u3053\u306b\u753b\u50cf\u306e\u8aac\u660e\u3092\u8ffd\u52a0)</li>"), $("#uploaded-images p, #uploaded-images ul").show())
  }});
  $("#insert-images").click(function(){
    $("#uploaded-images").toggle();
  });
  $("code.shell pre").snippet("c",{style:"the"});
  $("code.c pre").snippet("c",{style:"the"});
  $("code.cpp pre").snippet("cpp",{style:"the"});
  $("code.csharp pre").snippet("csharp",{style:"the"});
  $("code.css pre").snippet("css",{style:"the"});
  $("code.flex pre").snippet("flex",{style:"the"});
  $("code.html pre").snippet("html",{style:"the"});
  $("code.java pre").snippet("java",{style:"the"});
  $("code.javascript pre").snippet("javascript",{style:"the"});
  $("code.javascript_dom pre").snippet("javascript_dom",{style:"the"});
  $("code.perl pre").snippet("perl",{style:"the"});
  $("code.php pre").snippet("php",{style:"the"});
  $("code.python pre").snippet("python",{style:"the"});
  $("code.ruby pre").snippet("ruby",{style:"the"});
  $("code.sql pre").snippet("sql",{style:"the"});
  $("code.xml pre").snippet("xml",{style:"the"});

  $("#knob").toggle(
    function(){
      $("#index article").css({
        display: "none"
      });

      $("#index").animate({
        height: "32px"
      }, 300);
    }, function(){
      $("#index article").css({
        display: "block"
      });

      $("#index").animate({
        height: "300px"
      }, 300);
    }
  );


});
