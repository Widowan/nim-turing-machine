import strutils, times

type
    Machine = ref object
        initialState: string
        finalState:   string
        initHeadPos:  int
        rules:        seq[array[5, string]] # openArrays can't be nested, so.. (for 0.20.0 at least)


proc DrawTape(state: string, head: int, tape: string): void =
        var ctape = ""
        for n, i in tape:
            if n == head: ctape.add("[" & i & "]")
            else: ctape.add(if tape.len <= 24: " " & i & " " else: $i)
        echo state & spaces(5-state.len) & "| " & ctape


proc UTM(machine: Machine, tape: var string): void =
    var
        state = machine.initialState
        head  = machine.initHeadPos
        steps = 0

    DrawTape(state, head, tape)

    while 1==1:
        for rule in machine.rules:
            if tape.len > 70:
                state = machine.finalState
            elif state != machine.finalState and state == rule[0] and $tape[head] #[You also can't compare `string` and `char`]# == rule[1]:
                # You can't assign `string` to `char`. And there's no any method to convert it. That's so stupid..
                # `typeof("s"[0])` == char. MAAAAGIC
                tape[head] = rule[2][0]

                case rule[3]:
                    of "right":
                        head += 1
                        if head > tape.len-1:
                            tape.add("0")
                    of "left":
                        head -= 1
                        if head < 0:
                            tape.insert("0", 0)
                            head = 0
                    else: discard

                state  = rule[4]
                steps += 1

                DrawTape(state, head, tape)

        if state == machine.finalState:
            if tape.len > 70:
                echo "Tape is too big. Maybe you've catched infinite loop?"
            echo "Total steps: " & $steps
            break



var tapes = ["s0011221100s", "111"]
for tape in tapes.mitems:
    var machine = Machine(
        # initialState: "q1",
        # finalState:   "q0",
        # initHeadPos:  1,
        # rules: @[
        #     ["q1", "s", "1", "left" , "q0"],
        #     ["q1", "0", "1", "right", "q3"],
        #     ["q1", "1", "2", "right", "q1"],
        #     ["q1", "2", "0", "right", "q3"],
            
        #     ["q2", "s", "2", "stay" , "q0"],
        #     ["q2", "0", "2", "right", "q2"],
        #     ["q2", "1", "0", "right", "q1"],
        #     ["q2", "2", "1", "right", "q2"],
            
        #     ["q3", "s", "0", "right", "q0"],
        #     ["q3", "0", "2", "left" , "q2"],
        #     ["q3", "1", "2", "stay" , "q3"],
        #     ["q3", "2", "2", "left" , "q1"],
        # ]

        # initialState: "q0",
        # finalState:   "qf",
        # initHeadPos:  0,
        # rules: @[
        #     ["q0", "1", "1", "right", "q0"],
        #     ["q0", "0", "1", "stay",  "qf"]
        # ]

        # initialState: "a",
        # finalState:   "halt",
        # initHeadPos:  0,
        # rules: @[
        #     ["a", "0", "1", "right", "b"],
        #     ["a", "1", "1", "left",  "c"],
        #     ["b", "0", "1", "left",  "a"],
        #     ["b", "1", "1", "right", "b"],
        #     ["c", "0", "1", "left",  "b"],
        #     ["c", "1", "1", "stay",  "halt"]
        # ]
    )
    UTM(machine, tape)
    if tapes.find(tape) < tapes.len-1: echo ""

