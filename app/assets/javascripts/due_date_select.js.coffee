class @DueDateSelect
  constructor: ->
    # Milestone edit/new form
    $datePicker = $('.datepicker')

    if $datePicker.length
      $dueDate = $('#milestone_due_date')
      $datePicker.datepicker
        dateFormat: 'yy-mm-dd'
        onSelect: (dateText, inst) ->
          $dueDate.val(dateText)
      .datepicker('setDate', $.datepicker.parseDate('yy-mm-dd', $dueDate.val()))

    $('.js-clear-due-date').on 'click', (e) ->
      e.preventDefault()
      $.datepicker._clearDate($datePicker)

    # Issuable sidebar
    $loading = $('.js-issuable-update .due_date')
      .find('.block-loading')
      .hide()

    $('.js-due-date-select').each (i, dropdown) ->
      $dropdown = $(dropdown)
      $dropdownParent = $dropdown.closest('.dropdown')
      $datePicker = $dropdownParent.find('.js-due-date-calendar')
      $block = $dropdown.closest('.block')
      $selectbox = $dropdown.closest('.selectbox')
      $value = $block.find('.value')
      $valueContent = $block.find('.value-content')
      $sidebarValue = $('.js-due-date-sidebar-value', $block)

      fieldName = $dropdown.data('field-name')
      abilityName = $dropdown.data('ability-name')
      issueUpdateURL = $dropdown.data('issue-update')

      $dropdown.glDropdown(
        hidden: ->
          $selectbox.hide()
          $value.css('display', '')
      )

      addDueDate = (isDropdown) ->
        # Create the post date
        value = $("input[name='#{fieldName}']").val()

        if value isnt ''
          date = new Date value.replace(new RegExp('-', 'g'), ',')
          mediumDate = $.datepicker.formatDate 'yy-mm-dd', date
        else
          mediumDate = '无到期日'

        data = {}
        data[abilityName] = {}
        data[abilityName].due_date = value

        $.ajax(
          type: 'PUT'
          url: issueUpdateURL
          data: data
          dataType: 'json'
          beforeSend: ->
            $loading.fadeIn()
            if isDropdown
              $dropdown.trigger('loading.gl.dropdown')
              $selectbox.hide()
            $value.css('display', '')

            cssClass = if Date.parse(mediumDate) then 'bold' else 'no-value'
            $valueContent.html("<span class='#{cssClass}'>#{mediumDate}</span>")
            $sidebarValue.html(mediumDate)

            if value isnt ''
              $('.js-remove-due-date-holder').removeClass 'hidden'
            else
              $('.js-remove-due-date-holder').addClass 'hidden'
        ).done (data) ->
          if isDropdown
            $dropdown.trigger('loaded.gl.dropdown')
            $dropdown.dropdown('toggle')
          $loading.fadeOut()

      $block.on 'click', '.js-remove-due-date', (e) ->
        e.preventDefault()
        $("input[name='#{fieldName}']").val ''
        addDueDate(false)

      $.datepicker.regional['zh-CN'] = {
        closeText: '关闭',
        prevText: '&#x3C;上月',
        nextText: '下月&#x3E;',
        currentText: '今天',
        monthNames: ['一月','二月','三月','四月','五月','六月',
          '七月','八月','九月','十月','十一月','十二月'],
        monthNamesShort: ['一月','二月','三月','四月','五月','六月',
          '七月','八月','九月','十月','十一月','十二月'],
        dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
        dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
        dayNamesMin: ['日','一','二','三','四','五','六'],
        weekHeader: '周',
        isRTL: false,
        showMonthAfterYear: true,
        yearSuffix: '年'
      };
      $.datepicker.setDefaults($.datepicker.regional['zh-CN']);
      $datePicker.datepicker(
        dateFormat: 'yy-mm-dd',
        defaultDate: $("input[name='#{fieldName}']").val()
        altField: "input[name='#{fieldName}']"
        onSelect: ->
          addDueDate(true)
      )

    $(document)
      .off 'click', '.ui-datepicker-header a'
      .on 'click', '.ui-datepicker-header a', (e) ->
        e.stopImmediatePropagation()
