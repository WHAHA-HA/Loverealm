module DatepickerHelper
  def datepicker_helper(form, field, value, placeholder)
    if value
      parsed_value = Date.parse(value.to_s.to_s.delete!('-')).strftime('%m/%d/%Y')
    end
    form.text_field field.to_sym, id: 'datepicker', value: parsed_value, placeholder: placeholder, class: 'datepicker form-control'
  end
end
