function game(students) {
    students = JSON.parse(students)
    console.log(students)
    used_students = []
    points = 0
    for(var i =0; i < students.length; i++) {
        other_names = []
        correct = false
        current_student = random(students)
        while(used_students.include(current_student)){
            current_student = random(students)
        }
        while(other_names.length <= 3) {
            other_names << random(students.name)
            if(other_names.include(current_student)){
                remove(other_names, current_student.name)
            }
        }
        document.getElementById("imgArea").innerHTML = `<img src="${current_student.image}">`
        other_names << current_student.name
        for(var i = 0; i < 5; i++){
            name = []
            name << random(other_names)
            if(name == current_student.name){
                document.getElementById("nameArea").innerHTML = `<div id="option${i} current" class="names"> ${name} </div>`
            }else{
                document.getElementById("nameArea").innerHTML = `<div id="option${i}" class="names"> ${name} </div>`
            }
            remove(other_names, name)
        }
        if(document.getElementsByClassName("names").addEventListener("click", choice(current_student.name)) == true){
            points = points + 1
        };
        
        used_students << current_student
    }
    document.body.innerHTML = ""
    document.body.innerHTML = `<span class="">
                                    <a href="teachers/home" class="">
                                        <div class="">
                                            <p> You got ${points} out of ${students.length}. \n Press this button to go back home.</p>
                                        </div>
                                    </a>
                                </span>`

}

function choice(cName) {
    pickedName = this.textContent
    if(pickedName === cName){
        document.getElementById("current").classList.add("correct")
        return true
    } else{
        document.getElementById("").classList.add("wrong")
        document.getElementById("current").classList.add("right")
        return false
    }
}

function remove(arr, value){

    return arr.filter(function(ele){
        return ele != value
    })

}

function random(arr){
    return arr[Math.floor(Math.random() * arr.length)]
}