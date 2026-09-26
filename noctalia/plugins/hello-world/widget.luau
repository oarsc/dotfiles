local counter = 0

noctalia.setUpdateInterval(1000)

function update()
    counter = counter + 1
    barWidget.setText("Hello World " .. counter)
end