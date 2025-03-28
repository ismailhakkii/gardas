import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/theme/fun_app_theme.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/core/widgets/error_display_widget.dart';
import 'package:gardas/core/widgets/loading_widget.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/presentation/bloc/settings/settings_bloc.dart';
import 'package:gardas/presentation/bloc/user/user_bloc.dart';
import 'package:gardas/presentation/widgets/scaffold_wrapper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

/// Settings page with fun animations and UI
///
/// This page allows the user to configure application settings with a fun interface.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _backgroundAnimController;
  
  @override
  void initState() {
    super.initState();
    
    // Load settings
    context.read<SettingsBloc>().add(GetSettingsEvent());
    
    // Initialize animation controller
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    _backgroundAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      title: AppStrings.settingsTitle,
      currentIndex: 1,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundAnimController,
            builder: (context, child) {
              return CustomPaint(
                painter: _SettingsBackgroundPainter(
                  animation: _backgroundAnimController.value,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),
          
          // Main content
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading) {
                return const Center(
                  child: LoadingWidget(),
                );
              } else if (state is SettingsLoaded) {
                // Artık setState çağırmıyoruz, direkt olarak state.settings kullanıyoruz
                return _buildSettingsContent(state.settings);
              } else if (state is SettingsError) {
                return ErrorDisplayWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<SettingsBloc>().add(GetSettingsEvent());
                  },
                );
              } else {
                return const Center(
                  child: LoadingWidget(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(Settings settings) {
    // Yerel değişkenleri direkt settings'ten alıyoruz
    final soundEnabled = settings.soundEnabled;
    final soundVolume = settings.soundVolume;
    final vibrationEnabled = settings.vibrationEnabled;
    final notificationsEnabled = settings.notificationsEnabled;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildStaggeredWidgets([
          // Settings header with animation
          _buildSettingsHeader(context),
          
          const SizedBox(height: 32),
          
          // Profile section
          _buildSectionTitle(context, AppStrings.settingsProfile),
          const SizedBox(height: 16),
          _buildProfileSection(),
          
          const SizedBox(height: 24),
          
          // Theme mode settings
          _buildSectionTitle(context, AppStrings.settingsTheme),
          const SizedBox(height: 16),
          _buildThemeModeSection(context, settings.themeMode),
          
          const SizedBox(height: 24),
          
          // Language settings
          _buildSectionTitle(context, AppStrings.settingsLanguage),
          const SizedBox(height: 16),
          _buildLanguageSection(context, settings.languageCode),
          
          const SizedBox(height: 24),
          
          // Fun mode toggle
          _buildSectionTitle(context, 'Eğlenceli Mod'),
          const SizedBox(height: 16),
          _buildFunModeToggle(context, settings),
          
          const SizedBox(height: 24),
          
          // Sound & Vibration settings
          _buildSectionTitle(context, AppStrings.settingsSounds),
          const SizedBox(height: 16),
          _buildSoundSettings(context, soundEnabled, soundVolume),
          
          const SizedBox(height: 16),
          _buildVibrationSettings(context, vibrationEnabled),
          
          const SizedBox(height: 16),
          _buildNotificationSettings(context, notificationsEnabled),
          
          const SizedBox(height: 24),
          
          // About section
          _buildSectionTitle(context, AppStrings.settingsAbout),
          const SizedBox(height: 16),
          _buildAboutSection(context),
          
          const SizedBox(height: 24),
          
          // Data management
          _buildSectionTitle(context, AppStrings.settingsDataManagement),
          const SizedBox(height: 16),
          _buildDataManagementSection(context),
          
          const SizedBox(height: 80), // Bottom padding
        ]),
      ),
    );
  }
  
  List<Widget> _buildStaggeredWidgets(List<Widget> children) {
    // Uses the FunAnimations helper to create staggered entrance animations
    List<Widget> animatedChildren = [];
    
    for (int i = 0; i < children.length; i++) {
      animatedChildren.add(
        children[i]
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 50 * i),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad,
            )
            .slideY(
              delay: Duration(milliseconds: 50 * i),
              duration: const Duration(milliseconds: 400),
              begin: 30,
              curve: Curves.easeOutQuad,
            ),
      );
    }
    
    return animatedChildren;
  }

  Widget _buildSettingsHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: FunAppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(
              Icons.settings,
              size: 32,
              color: FunAppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.settingsTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Tercihleri Özelleştir',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: FunAppTheme.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
  
  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            _usernameController.text = state.user.username;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    GestureDetector(
                      onTap: _showAvatarSelector,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: FunAppTheme.primaryColor.withOpacity(0.2),
                            child: Text(
                              state.user.username.isNotEmpty ? 
                                state.user.username[0].toUpperCase() : 
                                'U',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: FunAppTheme.primaryColor,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: FunAppTheme.accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).cardTheme.color ?? Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ).animate()
                        .shimmer(delay: const Duration(seconds: 2), duration: const Duration(seconds: 2))
                        .then()
                        .shimmer(delay: const Duration(seconds: 5), duration: const Duration(seconds: 2)),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Username
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kullanıcı Adı',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.user.username,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Username edit field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: AppStrings.settingsUsername,
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check_circle),
                      onPressed: () {
                        if (_usernameController.text.isNotEmpty) {
                          context.read<UserBloc>().add(UpdateUsernameEvent(_usernameController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kullanıcı adı güncellendi')),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showAvatarSelector() {
    // Placeholder for avatar selection functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Avatar seçme özelliği yakında gelecek!'),
        backgroundColor: FunAppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildThemeModeSection(BuildContext context, AppThemeMode currentMode) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildThemeModeOption(
            context,
            'Sistem',
            Icons.brightness_auto,
            currentMode == AppThemeMode.system,
            () => _changeThemeMode(context, AppThemeMode.system),
          ),
          const Divider(),
          _buildThemeModeOption(
            context,
            'Açık Tema',
            Icons.light_mode,
            currentMode == AppThemeMode.light,
            () => _changeThemeMode(context, AppThemeMode.light),
          ),
          const Divider(),
          _buildThemeModeOption(
            context,
            'Koyu Tema',
            Icons.dark_mode,
            currentMode == AppThemeMode.dark,
            () => _changeThemeMode(context, AppThemeMode.dark),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? FunAppTheme.primaryColor : FunAppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : FunAppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: FunAppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: FunAppTheme.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Seçili',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: FunAppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, String currentLanguage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uygulama dili',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: currentLanguage,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.language),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade100
                  : FunAppTheme.primaryColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: AppLanguage.supportedLanguages.map((language) {
              return DropdownMenuItem<String>(
                value: language.code,
                child: Text(language.name),
              );
            }).toList(),
            onChanged: (languageCode) {
              if (languageCode != null) {
                context.read<SettingsBloc>().add(UpdateLanguageEvent(languageCode));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFunModeToggle(BuildContext context, Settings settings) {
    final bool isFunModeEnabled = settings.funModeEnabled;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eğlenceli Mod',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Animasyonlar ve eğlenceli arayüz öğeleri',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isFunModeEnabled,
            onChanged: (value) {
              context.read<SettingsBloc>().add(
                UpdateSettingsEvent(
                  settings.copyWith(funModeEnabled: value),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value 
                    ? 'Eğlenceli mod aktif!' 
                    : 'Eğlenceli mod kapatıldı'),
                  backgroundColor: value 
                    ? FunAppTheme.accentColor 
                    : Colors.grey,
                ),
              );
            },
            activeColor: FunAppTheme.accentColor,
            activeTrackColor: FunAppTheme.accentColor.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  // Parametre alan güncellemiş metodlar
  Widget _buildSoundSettings(BuildContext context, bool soundEnabled, double soundVolume) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              AppStrings.settingsSounds,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Oyun seslerini ve efektlerini aç/kapat',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            value: soundEnabled,
            onChanged: (value) {
              // setState() kullanmadan direk bloc event gönderiyoruz
              context.read<SettingsBloc>().add(UpdateSoundSettingsEvent(enabled: value));
            },
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: FunAppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  soundEnabled ? Icons.volume_up : Icons.volume_off,
                  color: FunAppTheme.primaryColor,
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          
          if (soundEnabled) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.volume_down,
                  size: 20,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Slider(
                    value: soundVolume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: '${(soundVolume * 100).round()}%',
                    onChanged: (value) {
                      // setState() kullanmadan direk bloc event gönderiyoruz
                      context.read<SettingsBloc>().add(UpdateSoundSettingsEvent(volume: value));
                    },
                  ),
                ),
                const Icon(
                  Icons.volume_up,
                  size: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVibrationSettings(BuildContext context, bool vibrationEnabled) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          AppStrings.settingsVibration,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Dokunmatik geri bildirim',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        value: vibrationEnabled,
        onChanged: (value) {
          // setState() kullanmadan direk bloc event gönderiyoruz
          context.read<SettingsBloc>().add(UpdateVibrationEvent(value));
        },
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: FunAppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.vibration,
              color: FunAppTheme.primaryColor,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, bool notificationsEnabled) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          AppStrings.settingsNotifications,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Oyun bildirimleri ve hatırlatıcılar',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        value: notificationsEnabled,
        onChanged: (value) {
          // setState() kullanmadan direk bloc event gönderiyoruz
          context.read<SettingsBloc>().add(UpdateNotificationsEvent(value));
        },
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: FunAppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.notifications,
              color: FunAppTheme.primaryColor,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAboutListTile(
            context,
            AppStrings.settingsAbout,
            Icons.info_outline,
            () {
              showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025',
              );
            },
          ),
          const Divider(),
          _buildAboutListTile(
            context,
            AppStrings.settingsPrivacyPolicy,
            Icons.privacy_tip_outlined,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          const Divider(),
          _buildAboutListTile(
            context,
            AppStrings.settingsTermsOfUse,
            Icons.description_outlined,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          const Divider(),
          _buildAboutListTile(
            context,
            'Uygulamayı Değerlendir',
            Icons.star_outline,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          const Divider(),
          _buildAboutListTile(
            context,
            'Uygulamayı Paylaş',
            Icons.share_outlined,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Versiyon: 1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAboutListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FunAppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            icon,
            color: FunAppTheme.primaryColor,
          ),
        ),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
}

  Widget _buildDataManagementSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDataManagementTile(
            context,
            AppStrings.settingsResetData,
            Icons.refresh,
            () {
              _showResetConfirmation(context);
            },
            warning: true,
          ),
          const Divider(),
          _buildDataManagementTile(
            context,
            AppStrings.settingsExportData,
            Icons.upload_file,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
          const Divider(),
          _buildDataManagementTile(
            context,
            AppStrings.settingsImportData,
            Icons.download,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bu özellik henüz mevcut değil')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDataManagementTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    {bool warning = false}
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: warning 
            ? Colors.red.withOpacity(0.1) 
            : FunAppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            icon,
            color: warning ? Colors.red : FunAppTheme.primaryColor,
          ),
        ),
      ),
      title: Text(
        title,
        style: warning 
          ? TextStyle(color: Colors.red.shade700)
          : null,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Veri Sıfırlama',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tüm verileriniz silinecek. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppStrings.cancel,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<SettingsBloc>().add(ResetSettingsEvent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veriler sıfırlandı')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(AppStrings.yes),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeThemeMode(BuildContext context, AppThemeMode themeMode) {
    context.read<SettingsBloc>().add(UpdateThemeModeEvent(themeMode));
  }
}

/// Custom painter for settings page background
class _SettingsBackgroundPainter extends CustomPainter {
  final double animation;
  final List<Offset> dots = [];
  
  _SettingsBackgroundPainter({
    required this.animation,
  }) {
    // Create some random dots for the background
    final random = math.Random(42);
    for (int i = 0; i < 50; i++) {
      dots.add(Offset(
        random.nextDouble(),
        random.nextDouble(),
      ));
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the background
    final bgPaint = Paint()
      ..color = FunAppTheme.primaryColor.withOpacity(0.05);
    
    // Fill background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    
    // Draw animated dots
    final dotPaint = Paint()
      ..color = FunAppTheme.primaryColor.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < dots.length; i++) {
      final offset = Offset(
        dots[i].dx * size.width,
        (dots[i].dy + animation * 0.1) % 1.0 * size.height,
      );
      
      final radius = size.width * 0.02 * (1 + math.sin(animation * 2 * math.pi + i) * 0.2);
      
      canvas.drawCircle(offset, radius, dotPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant _SettingsBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
