import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/core/widgets/error_display_widget.dart';
import 'package:gardas/core/widgets/loading_widget.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/presentation/bloc/settings/settings_bloc.dart';
import 'package:gardas/presentation/bloc/user/user_bloc.dart';

/// Settings page
///
/// This page allows the user to change application settings.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _usernameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Load settings
    context.read<SettingsBloc>().add(GetSettingsEvent());
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const LoadingWidget();
          } else if (state is SettingsLoaded) {
            return _buildSettingsForm(state.settings);
          } else if (state is SettingsError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<SettingsBloc>().add(GetSettingsEvent());
              },
            );
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }
  
  Widget _buildSettingsForm(Settings settings) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile section
        _buildSectionHeader(AppStrings.settingsProfile),
        _buildUsernameField(),
        const SizedBox(height: 8),
        _buildAvatarSelector(),
        
        const SizedBox(height: 24),
        
        // Theme section
        _buildSectionHeader(AppStrings.settingsTheme),
        _buildThemeSelector(settings.themeMode),
        
        const SizedBox(height: 24),
        
        // Language section
        _buildSectionHeader(AppStrings.settingsLanguage),
        _buildLanguageSelector(settings.languageCode),
        
        const SizedBox(height: 24),
        
        // Sound settings
        _buildSectionHeader(AppStrings.settingsSounds),
        _buildSoundSettings(
          enabled: settings.soundEnabled,
          volume: settings.soundVolume,
        ),
        
        const SizedBox(height: 24),
        
        // Vibration settings
        _buildVibrationSettings(settings.vibrationEnabled),
        
        const SizedBox(height: 24),
        
        // Notifications settings
        _buildNotificationSettings(settings.notificationsEnabled),
        
        const SizedBox(height: 24),
        
        // About section
        _buildSectionHeader(AppStrings.settingsAbout),
        _buildAboutSection(),
        
        const SizedBox(height: 24),
        
        // Data management
        _buildSectionHeader(AppStrings.settingsDataManagement),
        _buildDataManagementSection(),
      ],
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
  
  Widget _buildUsernameField() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          _usernameController.text = state.user.username;
          
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.settingsUsername,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomButton(
                text: AppStrings.save,
                onPressed: () {
                  if (_usernameController.text.isNotEmpty) {
                    context.read<UserBloc>().add(UpdateUsernameEvent(_usernameController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kullanıcı adı güncellendi')),
                    );
                  }
                },
                type: ButtonType.primary,
                size: ButtonSize.small,
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
  
  Widget _buildAvatarSelector() {
    return ElevatedButton(
      onPressed: () {
        // Would normally show avatar selection dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
        );
      },
      child: const Text(AppStrings.settingsChangeAvatar),
    );
  }
  
  Widget _buildThemeSelector(AppThemeMode currentTheme) {
    return Card(
      child: Column(
        children: [
          RadioListTile<AppThemeMode>(
            title: const Text(AppStrings.settingsLightTheme),
            value: AppThemeMode.light,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(UpdateThemeModeEvent(value));
              }
            },
          ),
          RadioListTile<AppThemeMode>(
            title: const Text(AppStrings.settingsDarkTheme),
            value: AppThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(UpdateThemeModeEvent(value));
              }
            },
          ),
          RadioListTile<AppThemeMode>(
            title: const Text(AppStrings.settingsSystemTheme),
            value: AppThemeMode.system,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(UpdateThemeModeEvent(value));
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildLanguageSelector(String currentLanguage) {
    return Card(
      child: Column(
        children: AppLanguage.supportedLanguages.map((language) {
          return RadioListTile<String>(
            title: Text(language.name),
            value: language.code,
            groupValue: currentLanguage,
            onChanged: (value) {
              if (value != null) {
                context.read<SettingsBloc>().add(UpdateLanguageEvent(value));
              }
            },
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildSoundSettings({required bool enabled, required double volume}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text(AppStrings.settingsSounds),
              value: enabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(UpdateSoundSettingsEvent(enabled: value));
              },
            ),
            if (enabled) ...[
              const SizedBox(height: 8),
              const Text(AppStrings.settingsVolume),
              Slider(
                value: volume,
                min: 0,
                max: 1,
                divisions: 10,
                label: '${(volume * 100).round()}%',
                onChanged: (value) {
                  // Update locally for smoother slider
                  setState(() {});
                },
                onChangeEnd: (value) {
                  context.read<SettingsBloc>().add(UpdateSoundSettingsEvent(volume: value));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildVibrationSettings(bool enabled) {
    return Card(
      child: SwitchListTile(
        title: const Text(AppStrings.settingsVibration),
        value: enabled,
        onChanged: (value) {
          context.read<SettingsBloc>().add(UpdateVibrationEvent(value));
        },
      ),
    );
  }
  
  Widget _buildNotificationSettings(bool enabled) {
    return Card(
      child: SwitchListTile(
        title: const Text(AppStrings.settingsNotifications),
        value: enabled,
        onChanged: (value) {
          context.read<SettingsBloc>().add(UpdateNotificationsEvent(value));
        },
      ),
    );
  }
  
  Widget _buildAboutSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.settingsAbout),
            onTap: () {
              // Show app info dialog
              showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text(AppStrings.settingsPrivacyPolicy),
            onTap: () {
              // Would normally open privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text(AppStrings.settingsTermsOfUse),
            onTap: () {
              // Would normally open terms of use
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDataManagementSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text(AppStrings.settingsResetData),
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Veri Sıfırlama'),
                  content: const Text('Tüm verileriniz silinecek. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<SettingsBloc>().add(ResetSettingsEvent());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Veriler sıfırlandı')),
                        );
                      },
                      child: const Text(AppStrings.yes),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text(AppStrings.settingsExportData),
            onTap: () {
              // Would normally export data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text(AppStrings.settingsImportData),
            onTap: () {
              // Would normally import data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
        ],
      ),
    );
  }
}