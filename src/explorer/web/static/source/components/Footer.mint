component Footer {
  fun render : Html {
    <>
      <footer class="footer">
        <div class="container">
          <div class="content has-text-centered">
            <p>
              <strong>
                "SushiChain Explorer"
              </strong>

              " by"

              <a href="https://github.com/SushiChain/explorer/graphs/contributors">
                " many"
              </a>

              " contributors. The source code is licensed"

              <a href="http://opensource.org/licenses/mit-license.php">
                " MIT"
              </a>

              "."
            </p>

            <p>
              <a
                class="icon"
                href="https://github.com/SushiChain/explorer">

                <img
                  src="/images/github-mark-64px.png"
                  width="64"
                  height="64"/>

              </a>
            </p>
          </div>
        </div>
      </footer>
    </>
  }
}
