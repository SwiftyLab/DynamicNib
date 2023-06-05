const initCount = 0;
window().outlets.countLabel.text = `${initCount}`;
var controller = {
    count: initCount,
    actionAdd: function (button) { this.count += 1; this.update(); },
    actionSubtract: function (button) { this.count -= 1; this.update(); },
    update: function () { window().outlets.countLabel.text = `${this.count}`; }
};
