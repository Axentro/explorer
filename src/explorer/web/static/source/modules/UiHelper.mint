module UiHelper {
  fun errorAlert (error : String) : Html {
    if (String.isEmpty(error)) {
      <div/>
    } else {
      <div
        class="alert alert-danger"
        role="alert">

        <button
          type="button"
          class="close"
          data-dismiss="alert"
          aria-label="Close">

          <i
            class="fas fa-times"
            title="close"/>

        </button>

        <{ error }>

      </div>
    }
  }

  fun successAlert (message : String) : Html {
    if (String.isEmpty(message)) {
      <div/>
    } else {
      <div
        class="alert alert-success"
        role="alert">

        <button
          type="button"
          class="close"
          data-dismiss="alert"
          aria-label="Close">

          <i
            class="fas fa-times"
            title="close"/>

        </button>

        <{ message }>

      </div>
    }
  }
}
