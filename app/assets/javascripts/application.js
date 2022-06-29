// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require js/bootstrap-datepicker
//= require bootstrap-sprockets
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.tagsinput
//= require js.cookie
//= require bootsy
//= require jquery.remotipart
//= require jquery.inview
//= require jquery.purr
//= require best_in_place
//= require chosen.jquery
//= require faye
//= require toastr
//= require typeahead.bundle
//= require_tree .

jQuery(document).ready(function($) {

    $('.best_in_place').best_in_place();

    $(".best_in_place").bind('ajax:error', function(evt,  data,  status,  xhr){
        $(this).next('.error').remove()
        $(this).after($('<div class="error"></div>').html(JSON.parse(data.responseText).errors.description[0]))
    });

    $(".best_in_place").bind('ajax:success', function(evt,  data,  status,  xhr){
        $(this).next('.error').remove()
    });



    $('body').on('mouseenter', '.tab-content.status-type .content', function(){
        $(this).find(".icons").show()//append( "<div class='icons'><i class='edit'></i><i class='delete'></i></div>" );
    });
    $('body').on('mouseleave', '.tab-content.status-type .content', function(){
        $(this).find(".icons").hide();
    });

    $('body').on('mouseenter', '.tab-content.image-type .editable', function(){
        $(this).find(".icons").show()//append( "<div class='icons'><i class='edit'></i><i class='delete'></i></div>" );
    });
    $('body').on('mouseleave', '.tab-content.image-type .editable', function(){
        $(this).find(".icons").hide();
    });

    $("body").on('click', '.icons .delete', function(data){
        var $this = $(this);
        var content_id = $this.data('content');
        var answer = confirm ("Are you sure ?")
        if (answer) {
            $.ajax({
                type: "DELETE",
                url: "/dashboard/contents/"+content_id,
                dataType: 'json',
                complete: function(response){
                    var contentType = response.responseJSON.content_type
                    if (response.status === 200) {
                        $this.closest('.' + contentType + '-type').remove();
                    };
                }
            });
        };
    });


    $('.status-type').hover(function() {
        $(this).find('.edit_button').show();
    }, function() {
        $(this).find('.edit_button').hide();
    })

    $('#tags').tagsInput({
        defaultText: $('#tags').attr('placeholder') || 'add tags',
        autocomplete_url:'/api/v1/web/hash_tags/autocomplete_hash_tags',
        autocomplete:{
            source: function(request, response) {
              $.ajax({
                 url: "/api/v1/web/hash_tags/autocomplete_hash_tags",
                 dataType: "json",
                 data: {
                    term: request.term
                },
                success: function(data) {
                    response( $.map( data, function( item ) {
                                    return {
                                        label: item.name,
                                        value: item.name
                                    }
                                }));
                    }
                })
            }}});

    $('#tags-without-autocomplete').tagsInput({
        defaultText: $('#tags-without-autocomplete').attr('placeholder')
    });


    $('#uploadBtn').on('change', function() {
        $("#uploadFile").val($(this).val());
    });

    setTimeout(function(){
        if ($('.alert').length > 0) {
            $('.alert').fadeOut(15000, function(){
            $(this).remove();
            });
        }
    });

   $(".hash_tag.add").click(function(event){
        event.preventDefault();
        return false;
   });

    var $gallery = $( ".row .hashes" ), $trash = $( ".chosen-tags" );
    // $( ".hashes .hash_tag" ).draggable({
    //   cancel: "a.ui-icon",
    //   revert: "invalid",
    //   containment: "document",
    //   helper: "clone",
    //   cursor: "move"
    // });
    // $( ".chosen-tags" ).droppable({
    //   accept: ".row .hashes .hash_tag",
    //   activeClass: "ui-state-highlight",
    //   drop: function( event, ui ) {
    //     var id = ui.draggable[0].getAttribute('data-id');

    //     $.ajax({
    //         type: "POST",
    //         url: "/hash_tags",
    //         data: {'hash_tag': {'id': id}},
    //         dataType: 'json',
    //         success: function(data){
    //             if($("span.placeholder").length > 0) {
    //                 $("span.placeholder").hide();
    //             }
    //         }
    //     });
    //     // ui.draggable.on('ajax:success', function (event, data, status, xhr) {
    //         addTag( ui.draggable );
    //     // });
    //   }
    // });

    // $(".welcome_first").on("click", ".hash_tag.remove", function(){
    //     if($(".hash_tag.add[data-id="+$(this).attr("data-id")+"]").length > 0) {
    //         $(".hash_tag.add[data-id="+$(this).attr("data-id")+"]").show();
    //     }
    //     if($(".chosen-tags a.hash_tag").length == 1) {
    //         if($("span.placeholder").length > 0) {
    //             $("span.placeholder").show();
    //         }
    //     }
    //     $(this).remove();
    // });

    $(".hash_tag.remove").click(function(){
        var tag= $("<a class='hash_tag add' style='margin-right: 5px;' data-method='post' data-remote='true' href='/hash_tags'/ data-id= " + $(this).attr("data-id") + " rel='nofollow'>" + $(this).text() + "</a>");
        tag.draggable({
              cancel: "a.ui-icon",
              revert: "invalid",
              containment: "document",
              helper: "clone",
              cursor: "move"
            });
        if($(".chosen-tags a.hash_tag").length == 1) {
            if($("span.placeholder").length > 0) {
                $("span.placeholder").show();
            }
            else {
                $(".chosen-tags").append( "<span class='placeholder'>Please drag and drop topics of interest here</span>" );
            }
        }
        tag.appendTo($(".span3.hashes"));
        $(this).remove();
    });

    function addTag( $item ) {
      $item.fadeOut(function() {
            var tag= $("<a class='hash_tag remove' data-method='delete' data-remote='true' href='/hash_tags/"+ $item.attr("data-id")+"'/ data-id= " + $item.attr("data-id") + " rel='nofollow'>" + $item.text() + "<i>x</i></a>");
            tag.appendTo( $trash ).fadeIn();
      });
    }

    $("#userName").keyup(function() {
        value = $(this).val();
        if (value.length == 0) {
            $('#search-results.inbox-auto-complete').empty();
            return;
        };
        $.ajax({
            type: "GET",
            url: "/users/get_users",
            data: { 'search' : value },
            dataType: "JSON",
            success: function(data) {
                var userList;
                if(data.length > 0) {
                    userList = "<ul>"
                    for (var i = 0; i < data.length; i++) {
                         userList += "<li><span data-id='"+data[i].id+"'>" + data[i].first_name + " " + data[i].last_name + "</a></li>";
                    }
                    userList += "</ul>"
                }

                $('#search-results.inbox-auto-complete').empty();
                $('#search-results.inbox-auto-complete').append(userList);
            }
        });
    });
    $("body").on("click", ".inbox-auto-complete span", function(){
        var selectedOptionID, selectedOptionName;
        selectedOptionID = $(this).data("id");
        selectedOptionName = $(this).text();
        $("#userName").val(selectedOptionName);
        $("#message_receiver_id").val(selectedOptionID);
        $('#search-results.inbox-auto-complete').empty();
    });

    // change: function(event,ui){
    //   $(this).val((ui.item ? ui.item.id : ""));
    // }
    $("body").on("click", "#load_more_link", function() {
        $(this).hide();
        $('html, body').animate({
            scrollTop: $("#footer").offset().top
        }, 1000);
    });

    // function newTag(element) {
    //    var tag= $("<a class='hash_tag remove' data-method='delete' data-remote='true' href='/hash_tags/"+ element.attr("data-id")+"'/ data-id= " + element.attr("data-id") + " rel='nofollow'>" + element.text() + "</a><br/>");
    //     tag.bind("click", function() {
    //         tag.hide();
    //         console.log(tag);
    //         console.log(element);
    //         element.show();
    //     });
    //     $(".chosen-tags").append(tag);
    // }

    // $('.hash_tag.add').on('ajax:success', function (event, data, status, xhr) {
    //     var $this = $(this);
    //     $this.hide();
    //     var this_id = $this.attr("data-id");
    //     newTag($this)
    // });

    $(".new-message a, .notifications-holder span.pull-right").click(function(e){
        e.preventDefault();
        $('#myModal').modal('show');
    });

    $(".feedback-section").click(function(e){
        e.preventDefault();
        $('.feedback-modal.modal').modal('show');
    });

    $(".tab-content #editable").click(function(e){
        e.preventDefault();
        var $this = $(this);
        $this.parent().siblings('.img-big.modal').modal('show');
    });

    $(".report-user a").click(function(e){
        e.preventDefault();
        $('.report-user-modal').modal('show');
    });

    $('.remove').on('click', function() {
        $(this).remove();
    });


    $(".chosen-select").chosen();

    $("#datepicker").datepicker({
      format: "mm/dd/yy",
      yearRange: "-100:+0",
      changeYear: true
    });
    $('.input-group.date').datepicker({
    });
    // $(".post__share").click(function() {
    //     $(this).hide();
    //   $(this).siblings( "ul.share-buttons" ).show();
    // });
    // $("ul.share-buttons").mouseleave(function() {
    //     $(this).hide();
    //   $(this).siblings( ".post__share" ).show();
    // });

    $("body").addClass("push-body");
    $("body").on("click", "#navigation-bar .user-profile",function(event){
        event.stopPropagation();
        $(".notifications-holder").hide();
        if($(this).hasClass("opened")){
            $(this).removeClass("opened");
            $(".user-mouse-over").hide();
            // $("body").removeClass("push-body-toleft");
        }
        else {
            $(this).addClass("opened");
            $(".user-mouse-over").slideDown();
            $(".inbox-icon-wrapper").removeClass("opened");
        }

    });

    $("body").on("click", "#navigation-bar .inbox-icon-wrapper",function(event){
        event.stopPropagation();
        if($(this).hasClass("opened")){
            $(this).removeClass("opened");
            $(".notifications-holder").hide();
            $(".user-profile").removeClass("opened");
                $(".user-mouse-over").hide();
            // $("body").removeClass("push-body-toleft");
        }
        else {
            $(".user-profile").removeClass("opened");
            $(".user-mouse-over").hide();
            $(this).addClass("opened");
            $(".notifications-holder").slideDown();
        }

    });

// function setCommentObj(data) {
//     if (data.user.avatar_url == "missing.jpg") {
//         var avatar_path = "/assets/"+data.user.avatar_url;
//     }else{
//         var avatar_path = data.user.avatar_url;
//     };
//     var commObj = {
//         body: data.body,
//         avatar: avatar_path,
//         nick: data.user.full_name
//     }
//     var commHTML = '<div class="comment-wrapper">';
//     commHTML += '<div id="avatar">';
//     commHTML += '<img width="30" height="30" src="'+commObj.avatar+'" class="thumb navbar-user-avatar menu-right push-body" alt="Missing">';
//     commHTML += '<h4>' + commObj.nick + '</h4>';
//     commHTML += '</div>';
//     commHTML += '<span>Just now</span>';
//     commHTML += '<div class="content">';
//     commHTML += '<br />' + commObj.body + '<br />';
//     commHTML += '</div>';
//     commHTML += '<hr />';
//     commHTML += '</div>';

//     return commHTML;
// }

$("body").on('click', '.post-status .post__comments, .single-story .post__comments, .recommend-story-wrapper .post__comments', function(){
    $(this).parent().siblings(".comments-wrapper").slideToggle();
});


 // $(document).on('ajax:success', 'form#new_comment',function (event, data, status, xhr) {
 //    console.log($(this));
 //    $(this).find("textarea").val("");
 //    $(this).parent().prev(".comments").show().append(setCommentObj(data));
 //    var val = $(this).parents(".post-status").find(".post__comments").text();
 //    $(this).parents(".post-status").find(".post__comments").text(val*1+1);
 //  });

 $("body").on('click', '.post__like', function(data){
    console.log('LIKE ---')
    var $this = $(this);
    var content_id = $this.attr('id');
    $.ajax({
        type: "PUT",
        url: "/dashboard/contents/"+content_id+"/like",
        data: {'like': {'content_id': content_id}},
        dataType: 'json',
        complete: function(data){
            var likesNumber = $this.text();
            $this.text(likesNumber*1+1);
            $this.removeClass("post__like").addClass('post__unlike');
        }
    });
 });

$("body").on('click', '.post__unlike', function(data){
    console.log('UNLIKE ---')
    var $this = $(this);
    var content_id = $this.attr('id');
    $.ajax({
        type: "PUT",
        url: "/dashboard/contents/"+content_id+"/dislike",
        data: {'like': {'content_id': content_id}},
        dataType: 'json',
        complete: function(data){
            var likesNumber = $this.text();
            $this.text(likesNumber*1-1);
            $this.removeClass("post__unlike").addClass('post__like');
        }
    });
 });

    $("p.second-level-tabs a").click(function (e) {
    	e.preventDefault();
    	var tabName = $(this).parent().data("id");
    	if($("." + tabName).is(':hidden')) {
    		$(".second-tabs-content").hide();
    		$("." + tabName).slideDown();
    	}
    	else {
    		$("." + tabName).slideUp();
    	}
        $(".validating-form form").validate({
            submitHandler: function(form) {
                console.log(form);
                form.submit();
            }
        });
    });

    $(".radio").each(function () {
    	if($(this).find("input").is(':checked')){
    		$(this).children("label").addClass("active");
    	}
    });

	$(".radio").click(function () {
    	if(!$(this).children("label").hasClass("active")){
    		$(this).children("label").addClass("active");
    		$(this).find("input").prop("checked", true);
    		$(this).siblings(".radio").children("label").removeClass("active");
    		$(this).siblings(".radio").find("input").prop("checked", false);
    	}
    });

    $(".login-link").click(function(e){
        e.preventDefault();
        $(this).toggleClass('opened')
        $('.form-signup, .form-login').toggleClass('home-current-form')
        // if($(this).hasClass("opened")) {
        //     $(this).removeClass("opened");
        //     $(".form-signup.col-sm-6").stop().animate({
        //         left:"0"
        //     }, 200 );
        //     $(".form-login.sidebar-login").stop().animate({
        //         right:"-38%"
        //     }, 200);
        // }
        // else {

        //     $(this).addClass("opened");
        //     $("#navigation-bar").hide();
        //     $(".form-signup.col-sm-6").stop().animate({
        //         left:"-38%"
        //     }, 200 );
        //     $(".form-login.sidebar-login").stop().animate({
        //         right:"0"
        //     }, 200);
        // }
    });

    $("body").click(function(event) {
        if(!$(event.target).closest('.sidebar-login').length) {
            // if($(".login-link").hasClass("opened") && !$(event.target).hasClass("login-link")) {
            //     console.log($(event.target));
            //     $(".login-link").removeClass("opened");
            //     $("#navigation-bar").fadeIn();
            //     $(".form-signup.col-sm-6").stop().animate({
            //         left:"0%"
            //     }, 200 );
            //     $(".form-login.sidebar-login").stop().animate({
            //         right:"-38%"
            //     }, 200);
            // }
            if($(".user-profile").hasClass("opened")) {
                $(".user-profile").removeClass("opened");
                $(".user-mouse-over").hide();
            }
            else {
                $(".inbox-icon-wrapper").removeClass("opened");
                $(".notifications-holder").hide();
            }
            if($(".inbox-icon-wrapper").hasClass("opened")){
                console.log($(event.target));
                $(".inbox-icon-wrapper").removeClass("opened");
                $(".notifications-holder").hide();
            }
        }
    });

    $(".load-img-wrapper").click(function(){
        $(".file.optional.user_avatar input").trigger("click");
    });

    // cnahge headline description

    $('.openings-icons').children('div').on('click', function() {
        var $this = $(this),
            text = $this.text();
      $this.closest('.openings-content').find('h4').text(text);

    });

        var $ul = $('.left-section ul'),
        $articles = $('.articles');


        $(window).scroll(function() {
            var offset = $(window).scrollTop();

            if(offset > 678) {
              $ul.addClass('fixed')
            } else {
              $ul.removeClass('fixed');
            }

        });

    });

// });
// Scrolling links function
// $(function() {
  // $('a[href*=#]:not([href=#])').click(function() {
  //   if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
  //     var target = $(this.hash);
  //     target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
  //     if (target.length) {
  //       $('html,body').animate({
  //         scrollTop: target.offset().top - 250
  //       }, 1000);
  //       return false;
  //     }
  //   }
  // });
// });
