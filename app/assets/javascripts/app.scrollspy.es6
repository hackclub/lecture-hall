class AppScrollSpy {
  constructor(parentEl, targetSelector, offset=0) {
    this.parentEl = parentEl;
    this.targetSelector = targetSelector;
    this.offset = offset;
  }

  init() {
    this.parentEl.scrollspy({
      target: this.targetSelector,
      offset: this.offset
    });
  }
}
