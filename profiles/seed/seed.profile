<?php
  use Drupal\Core\Extension\ThemeHandlerInterface;
/**
 * @file
 * Enables modules and site configuration for a standard site installation.
 */

// Include only when in install mode. MAINTENANCE_MODE is defined in
// core/install.php and in drush_core_site_install().
if (defined('MAINTENANCE_MODE') && MAINTENANCE_MODE == 'install') {
  include_once 'seed.install.inc';
}
/**
 * hook_form_alter() to alter the site configuration form.
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
  $form['profile_settings'] = array(
  '#type' => 'fieldset',
  '#title' => t('Profile Settings'),
  );
  $form['profile_settings']['seed_default_theme'] = array(
    '#prefix' => 'seed',
    '#title' => 'Select Theme',
    '#type' => 'select',
    '#options' => $theme_options,
    '#required' => TRUE,
  );
  $form['actions']['submit']['#submit']['seed'] = 'seed_install_profile_configure_form_submit';
}
/**
 * function to set selected theme as default theme.
 */
function seed_install_profile_configure_form_submit(&$form, $form_state) {
  // Set default theme.
  $theme = $form_state->getValue('seed_default_theme');
  \Drupal::configFactory()->getEditable('system.theme')->set('default', $theme)->save();
}
