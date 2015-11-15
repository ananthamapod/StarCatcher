const SERVO_MIN = 0.03;
const SERVO_MAX = 0.1;

const POT_MIN = 0;
const POT_MAX = 65535;
const POT_ZERO = 32767;
ERROR_RATIO <- (POT_ZERO/100).tofloat();

server.log("Hello HaackPrinceton");

laser <- hardware.pin2;

laser.configure(DIGITAL_OUT, 0);

timer_handle <- null;

servo <- hardware.pin7;

servo.configure(PWM_OUT, 0.02, SERVO_MIN);

state <- 0;

function setServo(speed) {
    if (speed < -1) speed = -1;
    if (speed > 1) speed = 1;

    servo.write(0.075 + speed * 0.025);
}

function startLight() {
    laser.write(1);
    server.log("light turned on");
}

function stopLight() {
    laser.write(0);
    server.log("light turned off");
}

function assignPotValue() {
    return (2.0 * math.rand() / RAND_MAX) - 1;
}


function assign() {
    local val = (assignPotValue());

    server.log(val);
    setServo(val);

    timer_handle <- imp.wakeup(1, assign);
}


function startEntertaining() {
    state <- 1;
    startLight();
    assign();
}

function stopEntertaining() {
    state <- 0;
    stopLight();
    imp.cancelwakeup(timer_handle);
    servo.write(0);
}


function setState(new_state) {
    if (new_state != state) {
        if (new_state == 0) {
            stopEntertaining();
        } else {
            startEntertaining();
        }
    }
}

agent.on("set.State", setState);

agent.on("tweet", @(x) server.log(x));

servo.write(0);
