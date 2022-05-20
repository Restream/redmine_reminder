var toggleExplicitList = function(selector, list, explicit_value) {
  var fnToggleList = function() {
    if ($(selector).val() == explicit_value) {
      $(list).show();
    } else {
      $(list).hide();
    }
  };

  $(selector).on('change', fnToggleList);

  fnToggleList();
};

toggleExplicitList(
    'reminder_configuration_issue_status_selector',
    'explicit_issue_statuses',
    'explicit'
);

toggleExplicitList(
    'reminder_configuration_project_selector',
    'explicit_projects',
    'explicit'
);

toggleExplicitList(
    'reminder_configuration_tracker_selector',
    'explicit_trackers',
    'explicit'
);
