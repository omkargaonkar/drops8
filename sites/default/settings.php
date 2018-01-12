<?php

/**
 * @file
 * Main Drupal configurations file.
 */

/**
 * Load services definition file.
 */
$settings['container_yamls'][] = __DIR__ . '/services.yml';

/**
 * Include the Pantheon-specific settings file.
 *
 * The settings.pantheon.php file makes some changes that affect all
 * envrionments that this site exists in.  Always include this file, even in
 * a local development environment, to insure that the site settings remain
 * consistent.
 */
include __DIR__ . "/settings.pantheon.php";

/**
 * Determine this is preproduction pantheon environment.
 */
if (isset($_ENV['PANTHEON_ENVIRONMENT']) && ($_ENV['PANTHEON_ENVIRONMENT'] != 'live' && $_ENV['PANTHEON_ENVIRONMENT'] != 'test')) {
  $pantheon_services_file = __DIR__ . '/services.pantheon.preproduction.yml';
  if (file_exists($pantheon_services_file)) {
    $settings['container_yamls'][] = $pantheon_services_file;
  }
  // Include pantheon configurations for preproduction environments.
  include __DIR__ . "/settings.dev_pantheon.php";
}

/**
 * If there is a local settings file, then include it.
 */
$local_settings = __DIR__ . "/settings.local.php";
if (file_exists($local_settings)) {
  include $local_settings;
}

/**
 * Hard set installation profile name.
 */
$settings['install_profile'] = 'seed';
