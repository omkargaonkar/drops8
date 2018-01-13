<?php

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
  foreach ($theme_handler->listInfo() as $theme_name => $theme_info) {
    if (!empty($theme_info->status)) {
      $theme_options[$theme_name] = $theme_info->info['name'];
    }
  }
  $form['default_theme'] = array(
    '#title' => 'Select Theme',
    '#type' => 'select',
    '#options' => $theme_options,
    '#required' => TRUE,
  );
  $form['actions']['submit']['#submit'][] = 'default_theme_submit';
}

function default_theme_submit(&$form, $form_state) {
  // Set default theme.
  $theme = $form_state->getValue('default_theme');
  \Drupal::configFactory()->getEditable('system.theme')->set('default', $theme)->save();
  // Set admin theme.
  $admin_theme = 'adminimal_theme';
  \Drupal::configFactory()->getEditable('system.theme')->set('admin', $admin_theme)->save();

  // Allow nodes to use admin theme.
  \Drupal::configFactory()->getEditable('node.settings')->set('use_admin_theme', TRUE)->save(TRUE);

  // Set site front page.
  \Drupal::configFactory()->getEditable('system.site')->set('page.front', '/home')->save(TRUE);

}
