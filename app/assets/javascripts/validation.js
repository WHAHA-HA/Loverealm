var Form = {

    validClass : 'valid',
    minLength : 1,

    validateLength : function(formEl){
        if(formEl.value.length < this.minLength ){
            if(formEl.classList.contains("valid-error")) {
                formEl.className.replace(/\bvalid-error\b/,'');
            }
            formEl.className += ' valid-error';
            $('.valid-error').parent().next('.error-message').show();
            $('.valid-error').parents().siblings('#imageError.error-message').show();
            $('.valid-error').next('.error-message').show()
            // formEl.nextSibling.neshow();
            return false;
        } else {
            if(formEl.className.indexOf(' '+Form.validClass) == -1)
            formEl.className += ' '+Form.validClass;
            return true;
        }
    },

    getSubmit : function(formID){
        var inputs = $('form').find('input');
        for(var i = 0; i < inputs.length; i++){
            if(inputs[i].type == 'submit'){
                return inputs[i];
            }
        }
        return false;
    }

};

$(document).ready(function() {
	// var validationForm = $('form');
    // var submit_button = Form.getSubmit('validationForm');
    // submit_button.disabled = 'disabled';

    // function checkForm(validationForm){
    //     var inputs = validationForm.find('.required-field');
    //     for(var i = 0; i < inputs.length; i++) {
    //         console.log(inputs[i].value);
    //         if(!Form.validateLength(inputs[i])){
    //             return false;
    //         }
    //         else if(inputs[i].classList.contains("valid-error")) {
    //             inputs[i].className = inputs[i].className.replace(/\bvalid-error\b/,'');
    //             inputs[i].nextSibling.hide();
    //         }
    //     }
    //     return true;
    // };

    // $('body').on('submit', 'form', function () {
    //     if (!checkForm($(this))) {
    //       return false;
    //     }else{
    //       return true;
    //     }
    // });

    $(".validating-form form").each(function() {
      $( this ).validate();
    });

    // $(".validating-form form").validate({
    //     submitHandler: function(form) {
    //         console.log("sasasa");
    //         console.log(form);
    //         form.submit();
    //     }
    // });
});
