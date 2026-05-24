/// Dedsec_BR design system — public API.
///
/// Convert from the React prototype at /layout_html_format/. Drops the
/// desktop wrapper (sidebar + AndroidDevice bezel) and exposes each phone
/// screen as a real Flutter widget. Internal screen navigation is preserved.
library;

export 'src/dedsec_app_root.dart';

export 'src/tokens/colors.dart';
export 'src/tokens/fonts.dart';
export 'src/tokens/theme.dart';

export 'src/state/app_state.dart';
export 'src/state/achievements.dart';
export 'src/state/analysis.dart';
export 'src/state/moderation.dart';
export 'src/state/ranking.dart';
export 'src/state/topics.dart';
export 'src/state/user.dart';

export 'src/atoms/avatar.dart';
export 'src/atoms/btn.dart';
export 'src/atoms/caution_tape.dart';
export 'src/atoms/dashed_box.dart';
export 'src/atoms/eye.dart';
export 'src/atoms/ghost_btn.dart';
export 'src/atoms/glitch.dart';
export 'src/atoms/grain.dart';
export 'src/atoms/halftone.dart';
export 'src/atoms/pixel_bar.dart';
export 'src/atoms/pixel_chip.dart';
export 'src/atoms/scanlines.dart';
export 'src/atoms/skull.dart';
export 'src/atoms/stencil.dart';
export 'src/atoms/wordmark.dart';

export 'src/molecules/badge_carousel.dart';
export 'src/molecules/badge_mosaic.dart';
export 'src/molecules/comic_panel.dart';
export 'src/molecules/news_card.dart';
export 'src/molecules/scope_chip.dart';
export 'src/molecules/tab_bar.dart';
export 'src/molecules/token_stream_panel.dart';
export 'src/molecules/top_bar.dart';

export 'src/organisms/analysis_overlay.dart';
export 'src/organisms/badge_share_modal.dart';
export 'src/organisms/moderation_overlay.dart';

export 'src/widgets/back_header.dart';
export 'src/widgets/ranking_panel.dart';
export 'src/widgets/screen_root.dart';
export 'src/widgets/stat_box.dart';
export 'src/widgets/sticky_footer.dart';
export 'src/widgets/toggle.dart';

export 'src/pages/route.dart';
export 'src/pages/splash_page.dart';
export 'src/pages/onboarding_page.dart';
export 'src/pages/interests_page.dart';
export 'src/pages/city_page.dart';
export 'src/pages/perms_page.dart';
export 'src/pages/home_page.dart';
export 'src/pages/detail_page.dart';
export 'src/pages/generate_page.dart';
export 'src/pages/channels_page.dart';
export 'src/pages/help_page.dart';
export 'src/pages/achievements_page.dart';
export 'src/pages/forum_scope_page.dart';
export 'src/pages/forum_list_page.dart';
export 'src/pages/topic_page.dart';
export 'src/pages/new_post_page.dart';
export 'src/pages/settings_page.dart';
