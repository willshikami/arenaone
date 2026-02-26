import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/navigation_actions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Scaffold(
        backgroundColor: const Color(0xFF0D0D10),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'PROFILE',
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -1.2),
              radius: 1.5,
              colors: [
                const Color(0xFFFF6A1A).withValues(alpha: 0.1),
                const Color(0xFF0D0D10),
              ],
              stops: const [0.0, 0.6],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      children: [
                        // Profile Header
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFF6A1A).withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color(0xFF1C1C26),
                                  child: SFIcon(
                                    SFIcons.sf_person_fill,
                                    color: Colors.white,
                                    fontSize: 50,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Alex Turner',
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@alexturner_sports',
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                ),
                                child: Text(
                                  'Die-hard Celtics fan • F1 enthusiast',
                                  style: GoogleFonts.instrumentSans(
                                    color: Colors.grey.shade300,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const SFIcon(SFIcons.sf_pencil, fontSize: 14, color: Color(0xFFFF6A1A)),
                                label: Text(
                                  'EDIT PROFILE',
                                  style: GoogleFonts.spaceMono(
                                    color: const Color(0xFFFF6A1A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  backgroundColor: const Color(0xFFFF6A1A).withValues(alpha: 0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Settings Section
                        _buildSectionHeader('PREFERENCES'),
                        const SizedBox(height: 16),
                        _buildSettingTile(
                          icon: SFIcons.sf_bolt_fill,
                          title: 'Live Activities',
                          subtitle: 'Track scores in real-time on Lock Screen',
                          trailing: Switch.adaptive(
                            value: vm.liveActivitiesEnabled,
                            activeColor: const Color(0xFFFF6A1A),
                            onChanged: vm.onSetLiveActivities,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSettingTile(
                          icon: SFIcons.sf_bell_fill,
                          title: 'Notifications',
                          subtitle: 'Manage alerts and reminders',
                          onTap: () {},
                        ),
                        const SizedBox(height: 48),
                        
                        // Log out button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              foregroundColor: Colors.red.shade400,
                            ),
                            child: Text(
                              'LOG OUT',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.spaceMono(
          color: Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SFIcon(icon, color: Colors.white, fontSize: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.instrumentSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing else Icon(Icons.chevron_right, color: Colors.grey.shade700),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, ProfilePage, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        liveActivitiesEnabled: state.liveActivitiesEnabled,
        onSetLiveActivities: (value) => dispatch(SetLiveActivitiesAction(value)),
      );
}

class _ViewModel extends Vm {
  final bool liveActivitiesEnabled;
  final ValueChanged<bool> onSetLiveActivities;

  _ViewModel({
    required this.liveActivitiesEnabled,
    required this.onSetLiveActivities,
  }) : super(equals: [liveActivitiesEnabled]);
}
