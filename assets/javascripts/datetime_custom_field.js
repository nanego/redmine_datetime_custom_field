/* DateTimePicker insertions */
function addFilter(field, operator, values) {
  var fieldId = field.replace('.', '_');
  var tr = $('#tr_'+fieldId);

  var filterOptions = availableFilters[field];
  if (!filterOptions) return;

  if (filterOptions['remote'] && filterOptions['values'] == null) {
    $.getJSON(filtersUrl, {'name': field}).done(function(data) {
      filterOptions['values'] = data;
      addFilter(field, operator, values) ;
    });
    return;
  }

  if (tr.length > 0) {
    tr.show();
  } else {
    if (filterOptions['type'] == "date" || filterOptions['type'] == "date_past" ) {
      buildDateTimeFilterRow(field, operator, values);
    } else {
      buildFilterRow(field, operator, values);
    }
  }

  $('#cb_'+fieldId).prop('checked', true);
  toggleFilter(field);
  $('#add_filter_select').val('').children('option').each(function() {
    if ($(this).attr('value') == field) {
      $(this).attr('disabled', true);
    }
  });

  // Patch
  addSelect2ToSelectTags()
}

function toggleMultiSelect(el) {
  if (el.attr('multiple')) {
    el.removeAttr('multiple');
    el.attr('size', 1);
  } else {
    el.attr('multiple', true);
    if (el.children().length > 10)
      el.attr('size', 10);
    else
      el.attr('size', 4);
  }
  // Patch
  addSelect2ToSelectTags()
}

function addSelect2ToSelectTags() {
  $(document).ready(function(){
    if ((typeof $().select2) === 'function') {
      $('#filters select.value').select2()
    }
  })
}

function buildDateTimeFilterRow(field, operator, values) {
  var fieldId = field.replace('.', '_');
  var filterTable = $("#filters-table");
  var filterOptions = availableFilters[field];
  if (!filterOptions) return;
  var tr = $('<tr class="filter">').attr('id', 'tr_'+fieldId).html(
    '<td class="field"><input checked="checked" id="cb_'+fieldId+'" name="f[]" value="'+field+'" type="checkbox"><label for="cb_'+fieldId+'"> '+filterOptions['name']+'</label></td>' +
    '<td class="operator"><select id="operators_'+fieldId+'" name="op['+field+']"></td>' +
    '<td class="values"></td>'
  );
  filterTable.append(tr);

  // Populate list of operators for this filter
  var i, select;
  var operators = operatorByType[filterOptions['type']];
  select = tr.find('td.operator select');
  for (i = 0; i < operators.length; i++) {
    var option = $('<option>').val(operators[i]).text(operatorLabels[operators[i]]);
    if (operators[i] == operator) { option.attr('selected', true); }
    select.append(option);
  }
  select.change(function(){ toggleOperator(field); });

  tr.find('td.values').append(
    '<span style="display:none;"><input type="text" name="v['+field+'][]" id="values_'+fieldId+'_1" size="10" class="value date_value" /></span>' +
    ' <span style="display:none;"><input type="text" name="v['+field+'][]" id="values_'+fieldId+'_2" size="10" class="value date_value" /></span>' +
    ' <span style="display:none;"><input type="text" name="v['+field+'][]" id="values_'+fieldId+'" size="3" class="value" /> '+labelDayPlural+'</span>'
  );
  $('#values_'+fieldId+'_1').val(values[0]);
  $('#values_'+fieldId+'_2').val(values[1]);
  $('#values_'+fieldId).val(values[0]);
  datetimepickerCreate('#values_'+fieldId+'_1');
  datetimepickerCreate('#values_'+fieldId+'_2');
}

function beforeShowDatePicker(input, inst) {
  var default_date = null;
  switch ($(input).attr("id")) {
    case "issue_start_date" :
      if ($("#issue_due_date").size() > 0) {
        default_date = $("#issue_due_date").val();
      }
      break;
    case "issue_due_date" :
      if ($("#issue_start_date").size() > 0) {
        default_date = $("#issue_start_date").val();
      }
      break;
  }
  datetimepickerCreate($(input).attr("id"));
  // $(input).datepicker("option", "defaultDate", default_date);
}
