class App {
  constructor() {
    this.analytics = new AppAnalytics();
    this.sentry = new AppSentry();
  }

  // Put any logic that should be run on every page here
  init() {
    let trackPage = true;

    if (this.page_metadata.analytics &&
        this.page_metadata.analytics.should_not_track_page) {
      trackPage = false;
    }

    if (trackPage) {
      this.trackPage();
    }
  }

  trackPage() {
    if (this.page_metadata) {
      let current_user = this.page_metadata.current_user;
      let analytics = this.page_metadata.analytics;

      if (current_user) {
        this.analytics.identify(current_user.id);
      }

      if (analytics) {
        let name = analytics.page_name;
        let category = analytics.page_category;

        if (name && category) {
          this.analytics.page(category, name);
        } else if (name) {
          this.analytics.page(name);
        }
      } else {
        this.analytics.page();
      }
    } else {
      this.analytics.page();
    }
  }
}

window.app = window.app || new App();

$(document).on('turbolinks:load', () => {
  window.app.init();
});
