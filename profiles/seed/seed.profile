<?php

/**
 * @file
 * Enables modules and site configuration for Seed site platform.
 */

// Include only when in install mode. MAINTENANCE_MODE is defined in
// core/install.php and in drush_core_site_install().
if (defined('MAINTENANCE_MODE') && MAINTENANCE_MODE == 'install') {
  include_once 'seed.install.inc';
}

/**
 * Implements hook_form_alter().
 */
function seed_form_install_configure_form_alter(&$form, $form_state) {
  // Get all available themes.
  $theme_list_info = \Drupal::service('theme_handler')->rebuildThemeData();
  $theme_options = [];
  foreach ($theme_list_info as $theme_name => $theme_info) {
    // Skip hidden themes.
    if (!empty($theme_info->info['hidden'])) {
      continue;
    }
    $theme_options[$theme_name] = $theme_info->info['name'];
  }
  // Add profile settings group.
  $form['profile_settings'] = [
    '#type' => 'fieldset',
    '#title' => t('Profile Settings'),
  ];
  // Default theme selection.
  $form['profile_settings']['seed_default_theme'] = [
    '#title' => 'Default theme',
    '#type' => 'select',
    '#options' => $theme_options,
    '#required' => TRUE,
  ];

  // Feature list.
  $features = [
    'seed_slider' => 'Slider',
  ];

  $form['profile_settings']['seed_default_features'] = [
    '#title' => 'Features',
    '#description' => t('Select features for your platform.'),
    '#type' => 'checkboxes',
    '#options' => $features,
  ];
  // Add custom submit handler to configure installation profile.
  $form['actions']['submit']['#submit'][] = 'seed_install_profile_configure_form_submit';
}

/**
 * Submit handler to configure installation profile.
 */
function seed_install_profile_configure_form_submit(&$form, $form_state) {
  // Get selected theme.
  $default_theme = $form_state->getValue('seed_default_theme');
  // Install selected theme along with dependencies.
  \Drupal::service('theme_installer')->install([$default_theme]);
  // Set default theme.
  \Drupal::service('theme_handler')->setDefault($default_theme);

  // Get selected features.
  $features = [];
  $features_selected = $form_state->getValue('seed_default_features');
  foreach ($features_selected as $name => $feature) {
    if (!empty($feature)) {
      $features[] = $name;
    }
  }
  // Enable required features.
  if (!empty($features)) {
    \Drupal::service('module_installer')->install($features, TRUE);
  }
}
