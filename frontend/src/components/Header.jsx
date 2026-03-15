import { useTranslation } from "react-i18next";

export default function  Header() {
 const { t } = useTranslation();
    return (
        <header className="bg-nutrium-green shadow-md">
            <div className="px-4 py-3 flex justify-between items-center">
                <img className="ml-8 w-30" src="nutrium-removebg.png" />
                <div className="mr-10 flex items-right gap-2 text-white">
                    <h2 className=" text-sm font-mediumb text-right">
                        {t("header")}
                    </h2>
                    <i className="fa-solid fa-arrow-right"></i>
                </div>
            </div>
        </header>
    )
}
