const Pagination = ({ paginaAtual, totalPaginas, aoMudarPagina }) => {
  // Criamos um array com os números das páginas para fazer o .map()
  const paginas = Array.from({ length: totalPaginas }, (_, i) => i + 1);

  return (
    <nav>
          <ul className="flex -space-x-px text-sm">
            <li>
              <button
                onClick={() => setPaginaAtual(prev => Math.max(prev - 1, 1))}
                disabled={paginaAtual === 1}
                className="flex items-center justify-center text-body bg-neutral-secondary-medium border border-default-medium rounded-s-base w-9 h-9 hover:bg-neutral-tertiary-medium disabled:opacity-50"
              >
                <span className="sr-only">Previous</span>
                <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m15 19-7-7 7-7" />
                </svg>
              </button>
            </li>

            {/* Gerar números de página dinamicamente */}
            {[...Array(totalPaginas)].map((_, index) => {
              const numPagina = index + 1; // Para começar em 1 em vez de 0
              return (
                <li key={numPagina}>
                  <button
                    onClick={() => setPaginaAtual(numPagina)}
                    className={`flex items-center justify-center border border-default-medium w-9 h-9 font-medium transition-colors ${paginaAtual === numPagina
                        ? 'bg-nutrium-green text-white' // Estilo quando está selecionada
                        : 'bg-neutral-secondary-medium text-body hover:bg-neutral-tertiary-medium'
                      }`}
                  >
                    {numPagina}
                  </button>
                </li>
              );
            })}

            {/* Botão Próximo */}
            <li>
              <button
                onClick={() => setPaginaAtual(prev => Math.min(prev + 1, totalPaginas))}
                disabled={paginaAtual === totalPaginas}
                className="flex items-center justify-center text-body bg-neutral-secondary-medium border border-default-medium rounded-e-base w-9 h-9 hover:bg-neutral-tertiary-medium disabled:opacity-50"
              >
                <span className="sr-only">Next</span>
                <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="m9 5 7 7-7 7" />
                </svg>
              </button>
            </li>
          </ul>
        </nav>
  );
};

export default Pagination;