
function plot_three_window(training_set_ii)

ax1 = axes('Position',[0.05 0.00 0.35 1.0]);
hold(ax1,'on')
imshow(training_set_ii.image1(201:301,201:301), [0, 3000], 'Parent', ax1,'Border','tight');
plot(51,51,'r+','MarkerSize',20);
ax2 = axes('Position',[0.35 0.00 0.35 1.0]);
hold(ax2,'on')

imshow(training_set_ii.image1, [0, 2000], 'Parent', ax2,'Border','tight');
plot(251,251,'r+','MarkerSize',20);
ax3 = axes('Position',[0.65 0.00 0.35 1.0]);
hold(ax3,'on')

imshow(training_set_ii.image3, [0, 1000], 'Parent', ax3,'Border','tight');
plot(training_set_ii.image3_loc(2),training_set_ii.image3_loc(1),'r+','MarkerSize',20);

end