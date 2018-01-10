<?php

/**
 * @file
 * Provides functionality to be used at install time.
 */

use Drupal\user\Entity\User;

/**
 * Implements hook_install_tasks().
 */
function seed_install_tasks(&$install_state) {
  // Generate an install task to install required modules.
  $tasks = [];
  $tasks['seed_wrapup'] = [];
  return $tasks;
}

/**
 * Perform batch processing for installation tasks.
 */
function seed_wrapup() {
  // Create default users.
  seed_create_default_users();
}

/**
 * Create default users.
 */
function seed_create_default_users() {
  $language = \Drupal::languageManager()->getCurrentLanguage()->getId();
  $roles = user_roles(TRUE);
  $authenticated = $roles[DRUPAL_AUTHENTICATED_RID];
  unset($roles['administrator']);
  unset($roles[DRUPAL_AUTHENTICATED_RID]);
  foreach ($roles as $rid) {
    $account = User::create();
    $user_role = $rid->get('id');
    // Mandatory settings.
    $account->setPassword($user_role);
    $account->enforceIsNew();
    $account->setEmail('test-' . $user_role . '@osseed.com');
    $account->setUsername('test-' . $user_role . '@osseed.com');

    // Optional settings.
    $account->set("init", 'email');
    $account->set("langcode", $language);
    $account->set("preferred_langcode", $language);
    $account->set("preferred_admin_langcode", $language);
    $account->activate();
    $account->addRole($user_role);
    // Save user.
    $user_account = $account->save();
  }
}
