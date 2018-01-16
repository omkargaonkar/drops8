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
  $theme_handler = \Drupal::service('theme_handler');
  $theme_options = [];
  $theme_list_info = $theme_handler->listInfo();
  foreach ($theme_list_info as $theme_name => $theme_info) {
    if (!empty($theme_info->status)) {
      if (!isset($theme_info->info['hidden']) || $theme_info->info['hidden'] != 1) {
        $theme_options[$theme_name] = $theme_info->info['name'];
      }
    }
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

  // Add custom submit handler to configure installation profile.
  $form['actions']['submit']['#submit'][] = 'seed_install_profile_configure_form_submit';
}

/**
 * Submit handler to configure installation profile.
 */
function seed_install_profile_configure_form_submit(&$form, $form_state) {
  // Set default theme.
  $theme = $form_state->getValue('seed_default_theme');
  \Drupal::configFactory()->getEditable('system.theme')->set('default', $theme)->save();
}
