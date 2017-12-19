# hw2_wind

<b>You and your partner’s names:</b>

Eloá and Mahad

<b>A description of what parameters you used in the visualization (number of particles, lifetime, step size, etc.):</b>

<b>Number of particles:</b> 
  2000
  
<b>Life:</b> 
randomly generated between 50 and 250

<b>dt:</b> 
0.1

<b>A discussion of how changing the step size for the integration affects the results:</b>

For this we tested with various step sizes, ranging from dt = 0.1 to dt = 0.4, and compared with the bilinear interpolation line we drew during the simulation on random points. Increasing the step size noticeably changed the accuracy of movement of wind, and generally there was a tendency for it to move 'outwards' or in a wider spiral formation. The particles or lines also appeared more erratic than smooth and continuous. Smaller step sizes progressively fixed this issue and alligned much better with the original euler interpolation line.

<b>A description of any wizardly work you did beyond the original scope of the assignment:</b>
  
We did some wizardly stuff such as drawing a line instead of points to see the a better semblance of direction in which the wind is moving. This was done by drawing a line from position We also did an interpolation of color based on a function that checks the magnitude of the vector at the point, and changes color from red to green accordingly. Moreover, these lines disappear in terms of opacity based on the life variable. While we ended up using a different model, we initially used a Processing tutorial for Simple Particle System by Daniel Shiffman. 

<a href="https://ibb.co/b0fJKm"><img src="https://preview.ibb.co/bF6Es6/Screen_Shot_2017_12_18_at_10_22_47_PM.png" alt="Screen_Shot_2017_12_18_at_10_22_47_PM" border="0"></a>
